//
//  BusinessService.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//
/*
 {
   "businessName": "Gardenedr Jond272",
   "street":  "123 John Dr",
   "city": "San Fransico",
   "state": "California",
   "zipCode": "18080",
   "intro": "We are a landscaping company",
   "phone": "12343534",
   "website" : "wwe.google.com"
 }
 */
import Foundation
struct BusinessCreationEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessName: String
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let intro: String
    let phone: String
    let website: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/create"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json",
         "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        [
            
            "businessName": businessName,
            "street": street,
            "city": city,
            "state": state,
            "zipCode": zipCode,
            "intro": intro,
            "phone": phone,
            "website": website
        ]
    }
    
    
}
struct GetBusinessData: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let userId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/userBusiness/\(userId)"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json",
         "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        nil
    }
    
    
}
struct GetAllServices: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)/services"
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
struct DeleteABusinessServiceEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let token: String
    let serviceId: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)/service/\(serviceId)"
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
struct UpdateBusinessDataEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let businessName: String?
    let intro: String?
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)"
    }
    
    var method: HTTPMethod {
        .put
    }
    
    var headers: [String : String]? {
        [
            
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        
        var dict: [String: Any] = [:]
        
        if let intro = intro {
            dict["intro"] = intro
        }
        
        if let businessName = businessName {
            dict["businessName"] = businessName
        }
        
        return dict
        
        
    }
    
    
}


struct CreateABusinessServiceEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let token: String
    let serviceName: String
    let description: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        
        "/business/\(businessId)/services"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: [String : String]? {
        [
            
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        [
            "serviceName": serviceName,
            "description": description
        ]
    }
    
    
}
struct UpdateBusinessServiceEndpoint: Endpoint {
    var multipartBody: (data: Data, contentType: String)? {
        nil
    }
    
    let businessId: String
    let serviceId: String
    let serviceName: String?
    let serviceDes: String?
    let token: String
    var baseURL: URL {
        URL(string: "https://localify.api.mananqayas.com/api")!
    }
    
    var path: String {
        "/business/\(businessId)/service/\(serviceId)"
    }
    
    var method: HTTPMethod {
        .put
    }
    
    var headers: [String : String]? {
        [
            
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any]? {
        var dict: [String: Any] = [:]
        
        if let serviceName = serviceName {
            dict["serviceName"] = serviceName
        }
        
        if let description = serviceDes {
            dict["description"] = description
        }
        
        return dict
    }
    
    
}


class BusinessService {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func createBusiness(businessName: String, street: String, city: String, state: String, zipCode: String, intro: String, phone: String, website: String) async -> Result<BusinessCreationResponseModel, NetworkError> {
        do {
            
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            let response: BusinessCreationResponseModel = try await networkManager.fetch(from: BusinessCreationEndpoint(businessName: businessName, street: street, city: city, state: state, zipCode: zipCode, intro: intro, phone: phone, website: website, token: token))
            UserDefaults.standard.set(true, forKey: "localifyBusinessCreated")
            return .success(response)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func getBusinessData() async -> Result<BusinessCreationResponseModel, NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            
            guard let ownerId = KeychainHelper.shared.read("ownerId") else {return .failure(.clientError(401))}
   
            let response: BusinessCreationResponseModel  = try await networkManager.fetch(from: GetBusinessData(userId: ownerId, token: token))
            KeychainHelper.shared.save(response.business.id, forkey: "ownerBusinessId")
         
            return .success(response)
            
            
            
        } catch {
    
            
            return .failure(.unknownError(-1))
        }
        
    }
    
    func getAllServices() async -> Result<BusinessServicesResponseModel, NetworkError> {
        
        do {
            
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
        
            
            let response: BusinessServicesResponseModel = try await networkManager.fetch(from: GetAllServices(businessId: businessId, token: token))
            
            return .success(response)
            
        } catch {
            return .failure(.unknownError(-1))
        }
        
    }
    
    func createABusinessService(serviceName: String, description: String) async -> Result<CreateBusinessServiceModelResponse, NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: CreateBusinessServiceModelResponse = try await networkManager.fetch(from: CreateABusinessServiceEndpoint(businessId: businessId, token: token, serviceName: serviceName, description: description))
            
            return .success(response)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
    
    func deleteAService(serviceId: String) async -> Result<CreateBusinessServiceModelResponse, NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: CreateBusinessServiceModelResponse = try await networkManager.fetch(from: DeleteABusinessServiceEndpoint(businessId: businessId, token: token, serviceId: serviceId))
            return .success(response)
            
        } catch {
       
            return .failure(.unknownError(-1))
        }
        
    }
    
    func updateABusiness(businessName: String?, intro: String?) async -> Result<BusinessCreationResponseModel, NetworkError> {
        do {
            
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: BusinessCreationResponseModel = try await networkManager.fetch(from: UpdateBusinessDataEndpoint(businessId: businessId, businessName: businessName, intro: intro, token: token))
            
            return .success(response)
            
        } catch {
            
            return .failure(.unknownError(-1))
        }
    }
    
    func updateBusinessService(serviceName: String?, description: String?, serviceId: String) async -> Result<CreateBusinessServiceModelResponse, NetworkError> {
        do {
            guard let token = KeychainHelper.shared.read("localifyToken") else {return .failure(.clientError(401))}
            guard let businessId = KeychainHelper.shared.read("ownerBusinessId") else {return .failure(.clientError(401))}
            
            let response: CreateBusinessServiceModelResponse = try await networkManager.fetch(from: UpdateBusinessServiceEndpoint(businessId: businessId, serviceId: serviceId, serviceName: serviceName, serviceDes: description, token: token))
            
            return .success(response)
        } catch {
            return .failure(.unknownError(-1))
        }
    }
}
