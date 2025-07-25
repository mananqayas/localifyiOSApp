//
//  ReviewService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import Foundation

struct GetAllBusinessReviewsEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let token: String
    let businessId: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)/reviews"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        [
            
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    
}
struct GetRatingsTotal: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let token: String
    let businessId: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)/reviews/total"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        [
            
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    
}
class ReviewService {
    
   private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getAllReviews() async -> Result<[SingleReviewModel], NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: [SingleReviewModel]  = try await networkManager.fetch(from: GetAllBusinessReviewsEndpoint(token: token, businessId: businessId))
            
            return .success(response)
        } catch {
            
            return .failure(.unknownError(-1))
        }
    }
    func getRatingsTotal() async -> Result<GetRatingsTotalRequestResponseModel, NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: GetRatingsTotalRequestResponseModel  = try await networkManager.fetch(from: GetRatingsTotal(token: token, businessId: businessId))
            
            return .success(response)
        } catch {
            
            return .failure(.unknownError(-1))
        }
    }
    

    
    
}

struct GetRatingsTotalRequestResponseModel: Codable {
    let averageRating: Double
}
