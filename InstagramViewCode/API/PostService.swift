//
//  PostService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 29/09/21.
//

import UIKit
import Firebase

struct PostService {
    
    static func UploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption, "timestamp": Timestamp(date: Date()), "imageUrl": imageUrl, "likes" : 0, "ownerUid": uid] as [String : Any]
            
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
        
    }
}
