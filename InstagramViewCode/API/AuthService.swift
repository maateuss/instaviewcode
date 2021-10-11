//
//  AuthService.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 14/09/21.
//

import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    
    static func loginUser(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void){
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                let data: [String: Any] = ["email": credentials.email, "fullname": credentials.fullname,  "uid": uid, "username": credentials.username, "profileImageUrl": imageUrl]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
            
        }
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    
}
