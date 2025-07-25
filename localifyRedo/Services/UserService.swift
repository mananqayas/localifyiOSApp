//
//  UserService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 12/06/2025.
//

import Foundation

struct GetUserProfileImageEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let token: String

    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/owner/profile"
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
struct UploadUserProfileImageEndpoint: Endpoint {
    let token: String
    let imageData: Data
    
    private let boundary: String

    init(token: String, imageData: Data) {
        self.token = token
        self.imageData = imageData
        self.boundary = UUID().uuidString
    }
    
    var multipartBody: (data: Data, contentType: String)? {
        let data = createMultipartBody(boundary: boundary)
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (data, contentType)
    }
    
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/user/loggedInUser/uploadProfilePicture"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        [
            "Authorization": "Bearer \(token)"
            // ✅ Do not set Content-Type here for multipart (handled automatically below)
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }

    private func createMultipartBody(boundary: String) -> Data {
        var body = Data()

        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"profilePicture\"; filename=\"profile.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        return body
    }
}

struct ProfileImageUploadResponseModel: Codable {
let profilePictureUrl: String
}
class UserService {
    let networkManager: NetworkManaging
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getUserImage() async -> Result<GetUserModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken") else {
            return .failure(.clientError(401))
        }
        do {
            let response: GetUserModel = try await networkManager.fetch(from: GetUserProfileImageEndpoint(token: token))
            return .success(response)
            
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func uploadImage(imageData: Data) async -> Result<ProfileImageUploadResponseModel, NetworkError> {
        guard let token = KeychainHelper.shared.read("localifyToken") else {
            return .failure(.clientError(401))
        }
        do {
       
          
            let response: ProfileImageUploadResponseModel = try await networkManager.fetch(from: UploadUserProfileImageEndpoint(token: token, imageData: imageData))
          
            
            return .success(response)
            
        } catch let error as NetworkError {
            return .failure(error)
        } catch {

            return .failure(.unknownError(-1))
        }
    }
}
