//
//  NotificationViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 10/10/21.
//

import UIKit

struct NotificationViewModel {
    // MARK: - Properties
    
    private let notification: Notification
    
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "")}
    
    var profileImageUrl: URL? { return URL(string: notification.userProfileImageUrl)}
    
    var username: String { return notification.username}
    var text: String { return notification.type.notificationMessage }
    
    var shouldHidePostImage: Bool { return notification.type == .follow }
    
    var attributedMessageText: NSAttributedString {
        let message = NSMutableAttributedString(string: username, attributes: [.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.black])
        message.append(NSAttributedString(string: " \(text) ", attributes: [.font : UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]))
        message.append(NSAttributedString(string: "20s", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return message
    }
    
    
    // MARK: - Lifecycle
    
    init(notification: Notification){
        self.notification = notification
    }
    
    // MARK: - Helpers
    
}

