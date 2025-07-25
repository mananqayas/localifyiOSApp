//
//  PostViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import Foundation
import UIKit
@MainActor
class PostViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var allPosts: [PostModel] = []
    @Published var singlePost: PostModel?
    let postService: PostService
    init(postService: PostService) {
        self.postService = postService
   

    }
    
    func fetchAllPosts() async {
        isLoading = true
        
        let response = await postService.getAllPosts()
        
        switch response {
            
        case .success(let response):
            print(response)
            
            allPosts = response
            isLoading = false
        case .failure(let error):
            print(error.localizedDescription)
            isLoading = false
        }
    }
    
    func fetchASinglePost(postId: String) async {
        
        let response = await postService.getASinglePost(postId: postId)
        
        switch response {
        case .success(let response):
            print(response)
            singlePost = response
        case .failure(let error):
            print(error)
        }
    }
    
    func updateASinglePost(postId: String, title: String?, content: String?, image: UIImage?) async -> Bool{
        let imageData = image?.jpegData(compressionQuality: 0.7)
        let response = await postService.updateASinglePost(postId: postId, title: title, content: content, image: imageData)
        
        switch response {
            
        case .success(let response):
            print(response)
            singlePost = response
            return true
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
    
    func deleteASinglePost(postId: String) async -> Bool {
        
        let response = await postService.deleteASinglePost(postId: postId)
        switch response {
            
        case .success(let response):
            print(response)
            return true
        case .failure(let error):
            print(error)
            return false
        }
    }
    
    func createASinglePost(title: String, content: String, image: UIImage) async -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return false}
        let response = await postService.createAPost(title: title, content: content, image: imageData)
        switch response {
            
        case .success(let response):
            print(response)
            return true
        case .failure(let error):
            print(error.localizedDescription)
            return false
        }
    }
    
    
    
    
    
}
