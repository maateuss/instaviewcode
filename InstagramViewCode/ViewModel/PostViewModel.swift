//
//  PostViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 30/09/21.
//

import UIKit


struct PostViewModel {
    private let post: Post
    
    var imageUrl : URL? {
        return URL(string: post.imageUrl)
    }
    
    var caption: String {
        return post.caption
    }
    
    
    
    var likes : Int { return post.likes }
    
    
    init(post: Post){
        self.post = post
    }
    
    
}
