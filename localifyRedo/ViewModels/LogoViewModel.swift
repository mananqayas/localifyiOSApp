//
//  LogoViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 15/06/2025.
//

import Foundation
import UIKit
@MainActor
class LogoViewModel: ObservableObject {
    let logoService: LogoService
    @Published var isLoading: Bool = false
    @Published var coverUrl: String?
    @Published var logoUrl: String?
    init(logoService: LogoService) {
        self.logoService = logoService
        
    }
    
    func fetchLogo() async {
        isLoading = true
        let response = await logoService.getLogo()
        
        switch response {
            
        case .success(let response):
            print(response)
            logoUrl = response.url
            isLoading = false
        case .failure(let error):
            
            print(error.localizedDescription)
            isLoading = false
        }
    }
    func uploadLogo(logo: UIImage) async -> Bool {
        
        let imageData = logo.jpegData(compressionQuality: 0.9)
        if let image = imageData {
            let response = await logoService.uploadLogo(logo: image)
            switch response {
            case .success(let response):
                print(response)
                return true
                
            case .failure(let error):
                print(error)
                return false
            }
        }
        
        return false
        
    }
    
    func updateLogo(logo: UIImage) async -> Bool {
        
         let imageData = logo.jpegData(compressionQuality: 0.9)
        if let image = imageData {
            let response = await logoService.updateLogo(logo: image)
            switch response {
            case .success(let response):
                print(response)
                return true
            
            case .failure(let error):
                print(error)
                return false
            }
        }
        return false
  
    }
    
    func getCover() async {
        isLoading = true
        let response = await logoService.getCover()
        
        switch response {
            
        case .success(let response):
            print(response)
            coverUrl = response.url
         print("got cover")
            isLoading = false
        case .failure(let error):
            
            print(error.localizedDescription)
            isLoading = false
        }
    }
    
    func uploadCover(cover: UIImage) async -> Bool {
        
        let imageData = cover.jpegData(compressionQuality: 0.9)
        if let image = imageData {
            let response = await logoService.uploadCover(cover: image)
            switch response {
            case .success(let response):
                print(response)
                return true
                
            case .failure(let error):
                print(error)
                return false
            }
        }
        
        return false
        
    }
    
    func updateCover(cover: UIImage) async -> Bool {
        
         let imageData = cover.jpegData(compressionQuality: 0.9)
        if let image = imageData {
            let response = await logoService.updateCover(cover: image)
            switch response {
            case .success(let response):
                print(response)
                return true
            
            case .failure(let error):
                print(error)
                return false
            }
        }
        return false
  
    }
    
    

    
    
}
