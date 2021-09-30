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
    var likes: Int
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    
    init(postId: String, dictionary: [String: Any]){
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
    }
    
    
    
    
}
