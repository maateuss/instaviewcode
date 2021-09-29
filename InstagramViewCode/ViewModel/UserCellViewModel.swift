//
//  UserCellViewModel.swift
//  InstagramViewCode
//
//  Created by Mateus Santos on 28/09/21.
//

import Foundation

struct UserCellViewModel {
    
    private let user: User
    
    var fullname: String{
        return user.fullname
    }
   
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String{
        return user.username
    }
    
    
    
    init(user: User) {
        self.user = user
    }
}
