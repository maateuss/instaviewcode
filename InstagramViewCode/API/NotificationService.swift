//
//  NotificationService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 10/10/21.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUserUid: String, type: NotificationType, post: Post? = nil){
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return }
        guard toUserUid != currentUserUid else { return }
      
        let document =  COLLECTION_NOTIFICATIONS.document(toUserUid).collection("user_notifications").document()

        var data: [String:Any] = ["timestamp" : Timestamp(date: Date()),
                                  "userUid": currentUserUid,
                                  "type": type.rawValue]
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
            data["id"] = document.documentID
        }
        
        document.setData(data)
                            
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
