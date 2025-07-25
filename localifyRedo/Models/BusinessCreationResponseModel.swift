//
//  BusinessCreationResponseModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//


/*
 {
   "message": "Business created successfully",
   "business": {
     "_id": "684616afef9c0ca23cb567e9",
     "name": "Gardenedr Jond272",
     "owner": "684616a2ef9c0ca23cb567e6",
     "address": {
       "_id": "684616afef9c0ca23cb567e8",
       "street": "123 John Dr",
       "city": "San Fransico",
       "state": "California",
       "postal_code": "18080",
       "__v": 0
     },
     "phone": "12343534",
     "website": "wwe.google.com",
     "business_description": "We are a landscaping company",
     "services": [],
     "__v": 0
   }
 }
 */


/*
 "_id": "6847a854810e30aafbef8894",
      "business": "684793fd810e30aafbef87e2",
      "name": "test service",
      "description": "service description",
 */
struct CreateBusinessServiceModelResponse: Codable {
    let service: BusinessServiceSingleModel
}
struct BusinessServiceSingleModel: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
    }
}
struct BusinessServicesResponseModel: Codable {
    let message: String
    let services: [BusinessServiceSingleModel]
    
}

import Foundation
struct BusinessAddressModel: Codable {
    let id:  String
    let street: String
    let city: String
    let state: String
    let postalCode: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case street
        case city
        case state
        case postalCode = "postal_code"
    }
}
struct BusinessDetailsModel: Codable {
    let id: String
    let name: String
    let owner: String
    let address: BusinessAddressModel
    let phone: String
    let website: String
    let businessDescription: String
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case owner
        case address
        case phone
        case website
        case businessDescription = "business_description"
    }

}
struct BusinessCreationResponseModel: Decodable {
    let message: String
    let business: BusinessDetailsModel
    
    
}
