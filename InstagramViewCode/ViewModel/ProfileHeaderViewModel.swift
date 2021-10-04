//
//  ProfileHeaderViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 23/09/21.
//

import UIKit


struct ProfileHeaderViewModel {
    
    let user: User
    
    var fullname: String{
        return user.fullname
    }
   
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followButtonText: String{
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtomBackgroundColor : UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtomTextColor : UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var followers: NSAttributedString {
        return attributedStatText(value: user.stats?.followers ?? 0, label:"followers")
    }
    
    
    var following: NSAttributedString {
        return attributedStatText(value:  user.stats?.following ?? 0, label:"following")
    }
    
    
    
    var posts: NSAttributedString {
        return attributedStatText(value: user.stats?.posts ?? 0, label:"posts")
    }
    

    
    
    
    init(user: User){
        self.user = user
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attText
    }
    
    
    
}
