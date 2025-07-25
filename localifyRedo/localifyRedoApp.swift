//
//  localifyRedoApp.swift
//  localifyRedo
//
//  Created by Manan Qayas on 05/06/2025.
//

import SwiftUI

@main
struct localifyRedoApp: App {
    var body: some Scene {
        WindowGroup {
            let navState = NavigationState()
            
            
            // review service and view model
            let authService = AuthService()
            let authViewModel = AuthViewModel(authService: authService)
          
            
           // business service and view model
            let businessService = BusinessService()
            let businessViewModel = BusinessViewModel(businessService: businessService)
            
            // post service and view model
            let postService = PostService()
            let postViewModel = PostViewModel(postService: postService)
            
            // authservice and view model
            
            let reviewService = ReviewService()
            let reviewViewModel = ReviewViewModel(reviewService: reviewService)
            
            // userservice and view model
            let userService = UserService()
            let userViewModel = UserViewModel(userService: userService)
            
            // portfolio service and view model
            let portfolioService = PortfolioService()
            let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
            
            // logo service and view model
            let logoService = LogoService()
            let logoViewModel = LogoViewModel(logoService: logoService)
        
            
            ContentView(
            
                authViewModel: authViewModel,
                businessViewModel: businessViewModel,
                reviewViewModel: reviewViewModel,
                postViewModel: postViewModel,
                userViewModel: userViewModel,
                portfolioViewModel: portfolioViewModel,
                logoViewModel: logoViewModel
            )
            .environmentObject(navState)
            .environmentObject(authViewModel)
//            CameraView()
          
        }
    
    }
}
