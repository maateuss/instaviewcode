//
//  Notification.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 09/10/21.
//

import Firebase

enum NotificationType : Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String{
        switch self {
        case .like: return "liked your post"
        case .follow: return "started following you"
        case .comment: return "commented on your post"
        }
    }
}

struct Notification {
    let userId : String
    var postImageUrl : String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let username: String
    
    init(dictionary: [String:Any]){
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.userProfileImageUrl = dictionary["userImageUrl"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.username = dictionary["username"] as? String ?? ""
    }
    
}
