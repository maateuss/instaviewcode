//
//  Comment.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import Firebase

struct Comment {
    let postUid : String
    let ownerUid : String
    let timestamp : Timestamp
    let content : String
    let commentUid : String
    init(data : [String: Any], postUid: String, commentUid: String){
        self.postUid = postUid
        ownerUid = data["ownerUid"] as? String ?? ""
        timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        content = data["content"] as? String ?? ""
        self.commentUid = commentUid
    }
    
}
