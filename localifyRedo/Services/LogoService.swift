//
//  LogoService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 15/06/2025.
//

import Foundation

struct LogoGetRequestEndpoint: Endpoint {
    let businessId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/logo/\(businessId)"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        [
   
            "Authorization": "Bearer \(token)",
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
struct UploadLogoEndpoint: Endpoint {
    let logo: Data
    let token: String
    let businessId: String

    private let boundary: String
    init(logo: Data, token: String, businessId: String) {
        self.logo = logo
        self.token = token
        self.businessId = businessId
        self.boundary = UUID().uuidString
      
    }
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/logo/\(businessId)"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        [
            
            "Authorization" : "Bearer \(token)"
        ]
    }
    
    
    var parameters: [String : Any]? {
        nil
    }
    
    var multipartBody: (data: Data, contentType: String)? {
        let data = createMultipartBody(boundary: boundary)
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (data, contentType)
    }
    
    
    private func createMultipartBody(boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"logo\"; filename=\"logo.jpeg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(logo)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
    
}
struct UpdateLogoEndpoint: Endpoint {
    let token: String
    let businessId: String
    let logo: Data
    private let boundary: String
    init(token: String, businessId: String, logo: Data) {
        self.token = token
        self.businessId = businessId
        self.logo = logo
        self.boundary = UUID().uuidString
    }
    
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/logo/\(businessId)"
    }
    
    var method: HTTPMethod {
        .put
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
    
    private func createMultipartbody(boundary: String)-> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"logo\"; filename=\"logo.jpeg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(logo)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }
}




struct GetBusinessBannerCoverEndpoint: Endpoint {
    let token: String
    let businessId: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        
        "/logo/cover/\(businessId)"
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
    
    var parameters: [String : Any]?  {
        nil
    }
     
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
}
struct UploadBusinessCoverEndpoint: Endpoint {
    let cover: Data
    let token: String
    let businessId: String

    private let boundary: String
    init(cover: Data, token: String, businessId: String) {
        self.cover = cover
        self.token = token
        self.businessId = businessId
        self.boundary = UUID().uuidString
      
    }
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/logo/cover/\(businessId)"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        [
            
            "Authorization" : "Bearer \(token)"
        ]
    }
    
    
    var parameters: [String : Any]? {
        nil
    }
    
    var multipartBody: (data: Data, contentType: String)? {
        let data = createMultipartBody(boundary: boundary)
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (data, contentType)
    }
    
    
    private func createMultipartBody(boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cover\"; filename=\"logo.jpeg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(cover)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
    
}

struct UpdateBusinessCoverEndpoint: Endpoint {
    let token: String
    let businessId: String
    let cover: Data
    private let boundary: String
    init(token: String, businessId: String, cover: Data) {
        self.token = token
        self.businessId = businessId
        self.cover = cover
        self.boundary = UUID().uuidString
    }
    
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/logo/cover/\(businessId)"
    }
    
    var method: HTTPMethod {
        .put
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
    
    private func createMultipartbody(boundary: String)-> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"cover\"; filename=\"logo.jpeg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(cover)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }
}
class LogoService {
    let networkManager: NetworkManaging
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager

    }
    
    func getLogo() async -> Result<LogoGetRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
        print(businessId)
        do {
            let response:LogoGetRequestResponseModel = try await networkManager.fetch(from: LogoGetRequestEndpoint(businessId: businessId, token: token))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }
    }
    func uploadLogo(logo: Data) async -> Result<LogoUploadRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
   
        do {
            let response:LogoUploadRequestResponseModel = try await networkManager.fetch(from: UploadLogoEndpoint(logo: logo, token: token, businessId: businessId  ))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }

    }
    func updateLogo(logo: Data) async -> Result<LogoUploadRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
   
        do {
            let response:LogoUploadRequestResponseModel = try await networkManager.fetch(from: UpdateLogoEndpoint(token: token, businessId: businessId, logo: logo))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }

    }
    
    
    // cover
    func getCover() async -> Result<LogoGetRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
 
        do {
            let response:LogoGetRequestResponseModel = try await networkManager.fetch(from: GetBusinessBannerCoverEndpoint(token: token, businessId: businessId))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }
    }
    func uploadCover(cover: Data) async -> Result<LogoUploadRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
   
        do {
            let response:LogoUploadRequestResponseModel = try await networkManager.fetch(from: UploadBusinessCoverEndpoint(cover: cover, token: token, businessId: businessId))
            
            return .success(response)
            
        } catch let error as NetworkError {
            print("Network error: \(error)")
            return .failure(error)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknownError(-1))
        }

    }
    func updateCover(cover: Data) async -> Result<LogoUploadRequestResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken"),
              let businessId = KeychainHelper.shared.read("ownerBusinessId")
            
                
        else { return .failure(.clientError(401)) }
   
        do {
            let response:LogoUploadRequestResponseModel = try await networkManager.fetch(from: UpdateBusinessCoverEndpoint(token: token, businessId: businessId, cover: cover))
            
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

