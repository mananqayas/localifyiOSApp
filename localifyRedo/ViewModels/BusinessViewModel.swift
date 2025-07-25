//
//  BusinessViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import Foundation
@MainActor
class BusinessViewModel: ObservableObject {
    let businessService: BusinessService
    @Published var isLoadingBusiness: Bool = false
    @Published var errorMessage: String?
    @Published var businessData: BusinessCreationResponseModel?
    @Published var businessServices: [BusinessServiceSingleModel] = []
 
    init(businessService: BusinessService) {
        self.businessService = businessService
  
    
    }
    
    @Published var businessName: String = ""
    @Published var street: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var ZipCode: String = ""
    @Published var intro: String = ""
    @Published var phone: String = ""
    @Published var website: String = ""
    
    func createBusiness() async -> Bool {
        let response = await businessService.createBusiness(businessName: businessName, street: street, city: city, state: state, zipCode: ZipCode, intro: intro, phone: phone, website: website)
        
        switch response {
            
        case .success(let response):
            let _ = response
            businessName = ""
            street = ""
            state = ""
            ZipCode = ""
            intro = ""
            phone = ""
            website = ""
            city = ""
            
            
            return true
        case .failure(let error):
         
            errorMessage = error.localizedDescription
            
            return false
        }
    }
    
    func getBusinessData() async {
        isLoadingBusiness = true
        let response = await businessService.getBusinessData()
        
        switch response {
        case .success(let response):
       
            self.businessData = response
            self.businessName = response.business.name
            self.intro = response.business.businessDescription
        
        
   
            isLoadingBusiness = false
        case .failure(let error):
   
            let _ = error
            isLoadingBusiness = false
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    func getBusinessServices() async {
        isLoadingBusiness = true
        let response = await businessService.getAllServices()
        
        switch response {
            
        case .success(let response):
            
            
            self.businessServices = response.services
            isLoadingBusiness = false
        case .failure(let error):
          
            isLoadingBusiness = false
        }
    }
    
    func createAService(name: String, description: String) async throws {
        print("Sending http request...")
        print("\(name), \(description)")
        let response = await businessService.createABusinessService(serviceName: name, description: description)
        switch response {
            
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    }
    
    func deleteAService(id: String) async {
        
        let response = await businessService.deleteAService(serviceId: id)
        switch response {
            
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    }
    
    func updateBusiness() async {
        print("request to update \(intro)")
        
        let response = await businessService.updateABusiness(businessName: businessName, intro: intro)
        
        switch response {
            
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    }
    
    func updateBusinessService(name: String, description: String, serviceId: String) async {
        
        let response = await businessService.updateBusinessService(serviceName: name, description: description, serviceId: serviceId)
        
        switch response {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
        
    }
    
}
