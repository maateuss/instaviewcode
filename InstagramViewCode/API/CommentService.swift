//
//  CommentService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 04/10/21.
//

import Firebase


struct CommentService {
    static func uploadComment(content: String, postUid: String, completion: @escaping(FirestoreCompletion)){
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        
        
        let data = ["timestamp": Timestamp(date: Date()),
                    "content": content,
                    "ownerUid" : ownerUid] as [String : Any]
        
        
        COLLECTION_POSTS.document(postUid).collection("comments").addDocument(data: data, completion: completion)
        
        
    }
    
    static func fetchComments(postUid: String, completion: @escaping([Comment]) -> Void){
        COLLECTION_POSTS.document(postUid).collection("comments").getDocuments() { snapshot,error in
            if let error = error {
                print("failed fetch comments: \(error.localizedDescription)")
                return
            } else {
                guard let documents = snapshot?.documents else { return }
                let comments = documents.map({ // Comment(data: $0.data(), postUid: postUid)
                    Comment(data: $0.data(), postUid: postUid, commentUid: $0.documentID)
                    
                })
                print(comments)
                completion(comments)
            }
        }
    }
    
}
