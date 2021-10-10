//
//  PostService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 29/09/21.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption, "timestamp": Timestamp(date: Date()), "imageUrl": imageUrl, "ownerUid": uid] as [String : Any]
            
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
        
    }
    
    
    static func fetchPosts(forUser: String, completion: @escaping([Post]) -> Void){
        let query = COLLECTION_POSTS.order(by: "timestamp", descending: true).whereField("ownerUid", isEqualTo: forUser)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: error getting posts \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map{ Post(postId: $0.documentID, dictionary: $0.data()) }
                   
            completion(posts)
        }
    }
    
    static func fetchPostStats(postUid: String, completion: @escaping(PostStats) -> Void){
        
        var likes = 0
        var numberOfComments = 0
        COLLECTION_POSTS.document(postUid).collection("post-likes").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            likes = snapshot.documents.count
            COLLECTION_POSTS.document(postUid).collection("comments").getDocuments {comntsnap, error in
                guard let comntsnap = comntsnap else { return }
                numberOfComments = comntsnap.documents.count
                completion(PostStats(likes: likes, comments: numberOfComments))
            }
        }
    }
    
    
    static func fetchPosts(completion: @escaping([Post]) -> Void){
        COLLECTION_POSTS.getDocuments { snapshot,error in
            if let error = error {
                print("DEBUG: error getting posts \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map{ Post(postId: $0.documentID, dictionary: $0.data()) }
            
            completion(posts)
            
        }
    }
    
    
    static func likePost(postUid: String, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(postUid).collection("post-likes").document(uid).setData([:]) {
            _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postUid).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(postUid: String, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(postUid).collection("post-likes").document(uid).delete() {
            _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(postUid).delete(completion: completion)
        }
    }
    
    static func fetchPostByUID(postUid: String, completion: @escaping(Post) -> Void){
        COLLECTION_POSTS.document(postUid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data() else { return }
            completion(Post(postId: postUid, dictionary: dictionary))
        }
    }
    
    
    static func checkIfUserLikedPost(postUid: String , completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(postUid).getDocument{
            (snapshot, err) in
            guard let userLiked = snapshot?.exists else { return }
            completion(userLiked)
        }
        
    }
    
    
    static func getOnlyFollowedByPosts(completion: @escaping([Post])-> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(uid).collection("user_following").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let query = COLLECTION_POSTS.whereField("ownerUid", in: documents.map({$0.documentID}))
            query.getDocuments { postsDocuments, postError in
                guard let postsThatCurrentUserIsFollowing = postsDocuments?.documents else { return }
                let followingPostsList = postsThatCurrentUserIsFollowing.map({Post(postId: $0.documentID, dictionary: $0.data())})
                print(followingPostsList)
                completion(followingPostsList)
            }
        }
        
    }
    
    
    
}
