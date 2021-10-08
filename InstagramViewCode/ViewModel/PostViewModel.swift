//
//  PostViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 30/09/21.
//

import UIKit
import Firebase

struct PostViewModel {
    var post: Post
    private let user: User

    var imageUrl : URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String{
        return user.username
    }
    
    var timestamp: Timestamp {
        return post.timestamp
    }
    
    var liked : Bool {
        return post.likedByCurrentUser
    }
    
    var likeImage : UIImage {
        return liked ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected")
    }
    
    var tintColor : UIColor {
        return liked ? .red : .black
    }
    
    
    var likes : Int { return post.stats?.likes ?? 0 }
    
    
    init(post: Post, user: User){
        self.post = post
        self.user = user
    }
    
    
}
