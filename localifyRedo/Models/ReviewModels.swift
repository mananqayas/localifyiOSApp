//
//  ReviewModels.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import Foundation


struct SingleReviewModel: Codable, Identifiable {
    
    let id: String
    let rating: Int
    let comment: String
    let createdAt: String
    let user: SingleReviewUser
    private enum CodingKeys:String,  CodingKey {
        case id = "_id"
        case rating
        case comment
        case createdAt
        case user
        
    }
    
}


struct SingleReviewUser: Codable {
    let fName: String
    let lName: String
}
