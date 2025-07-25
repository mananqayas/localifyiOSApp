//
//  PortfolioService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 14/06/2025.
//

import Foundation

struct GetAllPortfolioEndpoint: Endpoint {
    let token: String
    let businessId: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/portfolio/\(businessId)"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        [
            "Authorization" : "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    
}

struct UploadPortfolioImageEndpoint: Endpoint {
    let token: String
    let businessId: String
    private let boundary: String
    let image: Data
    init(token: String, businessId: String, image: Data) {
        self.token = token
        self.businessId = businessId
        self.boundary = UUID().uuidString
        self.image = image
    }
    
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/portfolio/\(businessId)"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        [
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    var multipartBody: (data: Data, contentType: String)? {
        
        let data = createMultipartbody(boundary: boundary)
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (data, contentType)
    }
    
    private func createMultipartbody(boundary: String) -> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"portfolio.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(image)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
        
        
    }
}

struct DeletePhotoByIdEndpoint: Endpoint {
    let token: String
    let businessId: String
    let photoId: String
    
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/portfolio/\(businessId)/\(photoId)"
    }
    
    var method: HTTPMethod {
        .delete
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
    
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    
}

class PortfolioService {
    
    let networkManager: NetworkManaging
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
     
    }
    
    func getAllPortfolioImages() async -> Result<PortfolioResponse, NetworkError> {
        
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
        
        else { return .failure(.clientError(401)) }
        
        do {
            
            let response: PortfolioResponse  = try await networkManager.fetch(from: GetAllPortfolioEndpoint(token: token, businessId: businessId))
            print("getting photos")
            return .success(response)
        } catch {
            
            return .failure(.unknownError(-1))
        }
        
    }
    
    func uploadPortfolioImage(image: Data) async -> Result <UploadPortfolioImageResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
        
        else { return .failure(.clientError(401)) }
        do {
            let response: UploadPortfolioImageResponseModel  = try await networkManager.fetch(from: UploadPortfolioImageEndpoint(token: token, businessId: businessId, image: image))
     
            return .success(response)
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }
    }
    
    func deletePortfolioImage(portfolioId: String) async -> Result<DeletePortfolioResponseModel, NetworkError>{
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
        
        else { return .failure(.clientError(401)) }
        do {
            
            let response: DeletePortfolioResponseModel = try await networkManager.fetch(from: DeletePhotoByIdEndpoint(token: token, businessId: businessId, photoId: portfolioId))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }
    }
    }
    
  

struct DeletePortfolioResponseModel: Codable {
    
    let message: String
}
struct UploadPortfolioImageResponseModel: Codable {
    
    let photo: PortfolioModel
}
