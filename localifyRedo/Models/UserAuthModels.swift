//
//  UserAuthModels.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import Foundation
/*
 {
   "id": "684616a2ef9c0ca23cb567e6",
   "email": "mandadnqcayas960@gmail.com",
   "role": "owner",
   "profilePicture": "",
   "fName": "Manan",
   "lName": "Qayas",
   "username": "mananqayas5174"
 }
 */


struct GetUserModel: Decodable {
    
    let id: String
    let email: String
    let role: String
    let profilePicture: String
    let fName: String
    let lName: String
    let username: String
}
