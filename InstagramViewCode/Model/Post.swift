//
//  Post.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 30/09/21.
//


import Firebase

struct Post {
    
    var caption: String
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    var likedByCurrentUser = false
    var stats: PostStats?
    var user: User?
    
    init(postId: String, dictionary: [String: Any]){
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
    }
    
}


struct PostStats {
    let likes: Int
    let comments: Int
}
