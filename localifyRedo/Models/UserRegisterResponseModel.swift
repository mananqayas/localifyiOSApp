//
//  UserRegisterResponseModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import Foundation
struct UserRegisterResponseModel: Decodable {
    let message: String
    let token: String
    let owner: UserResponse
}

struct UserResponse: Decodable {
    let id: String
    let fName: String
    let lName: String
    let email: String
    let username: String
   
    let role: UserRole  // <-- Change from `owner: String` to `role: UserRole`
}

enum UserRole: String, Decodable {
    case user = "user"
    case owner = "owner"
}
