//
//  CommentCellViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import UIKit

struct CommentCellViewModel {
    let comment : Comment
    let user : User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var uid: String {
        return comment.commentUid
    }
    
    var username: String{
        return user.username
    }
    
    var content: NSAttributedString{
        
        let attrText =  NSMutableAttributedString(string: "\(username) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attrText.append(NSAttributedString(string:comment.content, attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        
        
        return attrText
    }
    
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = content
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
}
