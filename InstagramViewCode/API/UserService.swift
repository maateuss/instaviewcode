//
//  UserService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 23/09/21.
//

import Firebase
typealias FirestoreCompletion = (Error?) -> Void


struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(){
                let user = User(dictionary: data)
                completion(user)
            }
            
        }
        
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void){
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map( {User(dictionary: $0.data()) })
            completion(users)
        }
    }
    
    
    static func follow(uid: String, completion: @escaping (FirestoreCompletion) ){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user_following").document(uid).setData([:]) {
            error in
            if error != nil {
                return
            }
            
            COLLECTION_FOLLOWERS.document(uid).collection("user_followers").document(currentUserUid).setData([:], completion: completion)
        }
        
    }
    
    
    static func unfollow(uid: String, completion: @escaping (FirestoreCompletion) ){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user_following").document(uid).delete() {
            error in
            if error != nil {
                return
            }
            
            COLLECTION_FOLLOWERS.document(uid).collection("user_followers").document(currentUserUid).delete(completion: completion)
        }
        
    }
    
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        
        
        COLLECTION_FOLLOWING.document(currentUserUid).collection("user_following").document(uid).getDocument {
            (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
        
        
    }
    
    
    static func fetchUserStats(uid: String ,completion: @escaping(UserStats) -> Void){
        
        var following : Int = 0
        var followers : Int = 0
        var posts: Int = 0
        
        
        COLLECTION_FOLLOWING.document(uid).collection("user_following").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            following = snapshot.documents.count
            
            COLLECTION_FOLLOWERS.document(uid).collection("user_followers").getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                followers = snapshot.documents.count
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments{ (snapshot, error) in
                    guard let snapshot = snapshot else { return }
                    posts = snapshot.documents.count
                    completion(UserStats(followers: followers, following: following, posts: posts))
                    return
                }
                
            }
            
        }
        
    }
    
    static var userCache = [User]()
    
    static func fetchPostUser(uid: String, completion: @escaping(User) -> Void){
        let cached = userCache.filter {$0.uid == uid}
        if cached.count >= 1 {
            print("cached user! \(cached[0])")
            completion(cached[0])
            return
        }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("error fetching post user: \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("snap without data")
                return
            }
            
            let user = User(dictionary: data)
            
            userCache.append(user)
            
            completion(user)
        }
    }
    
    
}
