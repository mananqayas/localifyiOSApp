//
//  UserViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 12/06/2025.
//

import Foundation
import Combine
import UIKit
@MainActor
class UserViewModel: ObservableObject {
    @Published var imageUrl: String?
    @Published var isUploading = false
    @Published var isLoading  = false
    
    let userService: UserService
    init(userService: UserService) {
        self.userService = userService
      
    }
    
    func getProfileImage() async {
        isLoading = true
        let response = await userService.getUserImage()
        
        switch response {
            
        case .success(let response):
            imageUrl = response.profilePicture
            isLoading = false
        case .failure(let error):
            print(error.localizedDescription)
            isLoading = false
        }
    }
    func upload(image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }

        print("Image data size: \(imageData.count) bytes")
        let response = await userService.uploadImage(imageData: imageData)
        
        switch response {
            
        case .success(let response):
            imageUrl = response.profilePictureUrl
            print(response)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
