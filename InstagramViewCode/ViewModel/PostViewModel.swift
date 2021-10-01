//
//  PostViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 30/09/21.
//

import UIKit


struct PostViewModel {
    private let post: Post
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
    
    
    var likes : Int { return post.likes }
    
    
    init(post: Post, user: User){
        self.post = post
        self.user = user
    }
    
    
}