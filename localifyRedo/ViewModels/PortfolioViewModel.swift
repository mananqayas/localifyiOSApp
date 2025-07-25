//
//  PortfolioViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 14/06/2025.
//

import Foundation
import UIKit
@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var allPortfolioImages: [PortfolioModel] = []
    let portfolioService: PortfolioService
    init(portfolioService: PortfolioService) {
        self.portfolioService = portfolioService
        Task {
            
            await fetchAllPortfolioImages()
        }
    }
    
    func fetchAllPortfolioImages() async {
        isLoading = true
        
        let response = await portfolioService.getAllPortfolioImages()
        
        switch response {
            
        case .success(let response):
            allPortfolioImages = response.photos
            print(response)
            isLoading = false
            
        case .failure(let error):
            
            print(error.localizedDescription)
            isLoading = false
        }
    }
    
    func uploadPortfolioImage(image: UIImage) async -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {return false}
        
      let response =   await portfolioService.uploadPortfolioImage(image: imageData)
        
        switch response {
            
        case .success(let response):
            print(response)
            return true
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
    func deletePostById(photoId: String) async {
        let response = await portfolioService.deletePortfolioImage(portfolioId: photoId)
        
        switch response {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    }
}
