//
//  PostModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//
/*
 {
   "business": "6848584428337a727ed41329",
   "title": "Title",
   "content": "Content",
   "imageUrl": "",
   "videoUrl": "",
   "_id": "684a2a8cd4184dedb0c54c2f",
   "createdAt": "2025-06-12T01:17:00.493Z",
   "updatedAt": "2025-06-12T01:17:00.493Z"
 }
 */
import Foundation
struct PostModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let content: String
    let imageUrl: String
    let videoUrl: String
    let createdAt: String
    private enum CodingKeys:String, CodingKey {
        case id = "_id"
        case title
        case content
        case imageUrl
        case videoUrl
        case createdAt
    }
}
