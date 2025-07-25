//
//  PortfolioModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 14/06/2025.
//

import Foundation

/*
 {
    "_id": "684e02ea8c7f30a4f92fd2a9",
    "url": "https://localify-randeoahdakjd1.s3.us-east-1.amazonaws.com/684dd1cb45b9d826d03b136d/7629320d-c4ed-45a6-a4d1-80a66b002d41.png",
    "user": "684dd1b445b9d826d03b1369",
    "createdAt": "2025-06-14T23:16:58.362Z",
    "updatedAt": "2025-06-14T23:16:58.362Z",
    "__v": 0
  }
 */

struct PortfolioResponse: Codable {
    let photos: [PortfolioModel]
}
struct PortfolioModel: Codable {
    let id: String
    let url: String
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url
    }
}
