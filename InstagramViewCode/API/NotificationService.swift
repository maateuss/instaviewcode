//
//  NotificationService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 10/10/21.
//

import Firebase

struct NotificationService {
    static func uploadNotification(userToBeNotified: User,  type: NotificationType, post: Post? = nil){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        
        guard userToBeNotified.uid != currentUserUid else { return }
      
        UserService.fetchPostUser(uid: currentUserUid) { currentUser in
            
            let document =  COLLECTION_NOTIFICATIONS.document(userToBeNotified.uid).collection("user_notifications").document()

            var data: [String:Any] = ["timestamp" : Timestamp(date: Date()),
                                      "userUid": currentUserUid,
                                      "type": type.rawValue,
                                      "userImageUrl": currentUser.profileImageUrl,
                                      "username": currentUser.username]
            
            if let post = post {
                data["postId"] = post.postId
                data["postImageUrl"] = post.imageUrl
                data["id"] = document.documentID
            }
            
            document.setData(data)
                                
        }
      
    }
    
    static func uploadNotification(type: NotificationType, postUid: String){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        
        
        PostService.fetchPostByUID(postUid: postUid){
            post in
            
            UserService.fetchPostUser(uid: post.ownerUid) { userToBeNotified in
                
                guard userToBeNotified.uid != currentUserUid else { return }
                
                
                
                UserService.fetchPostUser(uid: currentUserUid) { currentUser in
                    
                    let document =  COLLECTION_NOTIFICATIONS.document(userToBeNotified.uid).collection("user_notifications").document()
                    
                    let data: [String:Any] = ["timestamp" : Timestamp(date: Date()),
                                              "userUid": currentUserUid,
                                              "type": type.rawValue,
                                              "userImageUrl": currentUser.profileImageUrl,
                                              "username": currentUser.username,
                                              "postId" : post.postId,
                                              "postImageUrl" : post.imageUrl,
                                              "id" : document.documentID]
                    document.setData(data)
                    
                }
            }
            
        }
    }
    
                                          
                                          
    static func fetchNotifications(completion: @escaping([Notification]) -> Void ){
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
            COLLECTION_NOTIFICATIONS.document(currentUserUid).collection("user_notifications").getDocuments{
                snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let notifications = documents.map({Notification(dictionary: $0.data())})
                
                completion(notifications)
            }
        

    }
    
}
