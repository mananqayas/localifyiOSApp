//
//  PostService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import Foundation

struct GetAllPostsEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/posts/\(businessId)"
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

struct GetASinglePostEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let postId: String
    let businessId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/posts/\(businessId)/\(postId)"
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

struct UpdateASinglePostEndpoint: Endpoint {
   
    
    let title: String?
    let content: String?
    let businessId: String
    let postId: String
    let token: String
    let image: Data?
    private let boundary: String
    init(title: String?, content: String?, businessId: String, postId: String, token: String, image: Data?) {
        self.title = title
        self.content = content
        self.businessId = businessId
        self.postId = postId
        self.token = token
        self.boundary = UUID().uuidString
        self.image = image
    }
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/posts/update/\(businessId)/\(postId)"
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
        let data = createMultipartBody(boundary: boundary)
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (data, contentType)
    }
    private func createMultipartBody(boundary: String) -> Data {
        
        var body = Data()
        let lineBreak = "\r\n"
        
        
        
        if let title = title {
            // title
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"title\"\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append("\(title)\(lineBreak)".data(using: .utf8)!)
        }
        
        
        if let content = content {
            // title
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"content\"\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append("\(content)\(lineBreak)".data(using: .utf8)!)
        }
        
        if let image = image {
            // Image
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"post.jpg\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(image)
            body.append(lineBreak.data(using: .utf8)!)
        }
        // Final boundary
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        
    
        
        return body
    }
    
 
}
struct DeleteSinglePostEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
  
    let businessId: String
    let postId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/posts/delete/\(businessId)/\(postId)"
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
    
 
}
struct CreateASinglePostEndpoint: Endpoint {
 
    
    let businessId: String
    let title: String
    let content: String
    
    
    private let boundary: String
    init(businessId: String, title: String, content: String, imageData: Data, token: String) {
        self.businessId = businessId
        self.title = title
        self.content = content
        self.boundary = UUID().uuidString
        self.imageData = imageData
        self.token = token
    }
    let imageData: Data
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/posts/create/\(businessId)"
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
        
        // Title
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"title\"\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append("\(title)\(lineBreak)".data(using: .utf8)!)
        
        // Content
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"content\"\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append("\(content)\(lineBreak)".data(using: .utf8)!)
        
        // Image
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"post.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append(lineBreak.data(using: .utf8)!)
        
        // Final boundary
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        return body
    }
}
struct APIMessageResponse: Decodable {
    let message: String
}
class PostService {
    
    let networkManager: NetworkManaging
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getAllPosts() async -> Result<[PostModel], NetworkError> {
        
        do {
            guard let token = KeychainHelper.shared.read("localifyToken"),
                  let businessId = KeychainHelper.shared.read("ownerBusinessId")
                    
            else {return .failure(.clientError(401))}
            let response: [PostModel] = try await networkManager.fetch(from: GetAllPostsEndpoint(businessId: businessId, token: token))
            
            return .success(response)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func getASinglePost(postId: String) async -> Result<PostModel, NetworkError>{
        
        do {
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId"),
                  let token = KeychainHelper.shared.read("localifyToken")
            else {return .failure(.clientError(401))}
            
            let response: PostModel = try await networkManager.fetch(from: GetASinglePostEndpoint(postId: postId, businessId: businessId, token: token))
            
            return .success(response)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func updateASinglePost(postId: String, title: String?, content: String?, image: Data?) async -> Result<PostModel, NetworkError> {
        guard let businessId = KeychainHelper.shared.read("ownerBusinessId"),
              let token = KeychainHelper.shared.read("localifyToken")
        
        else {return .failure(.clientError(401))}
        
        do {
            let response: PostModel = try await networkManager.fetch(from: UpdateASinglePostEndpoint(title: title, content: content, businessId: businessId, postId: postId, token: token, image: image))
            
            return .success(response)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    func createAPost(title: String, content: String, image: Data) async -> Result<PostModel, NetworkError>{
        guard let businessId = KeychainHelper.shared.read("ownerBusinessId"),
              let token = KeychainHelper.shared.read("localifyToken")
        
        else {return .failure(.clientError(401))}
        
        do {
            let response:PostModel = try await networkManager.fetch(from: CreateASinglePostEndpoint(businessId: businessId, title: title, content: content, imageData: image, token: token))
         
         
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func deleteASinglePost(postId: String) async -> Result<APIMessageResponse, NetworkError> {
        guard let businessId = KeychainHelper.shared.read("ownerBusinessId"),
              let token = KeychainHelper.shared.read("localifyToken")
        
        else {return .failure(.clientError(401))}
        
        do {
            let response: APIMessageResponse = try await networkManager.fetch(from: DeleteSinglePostEndpoint(businessId: businessId, postId: postId, token: token))
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
}
