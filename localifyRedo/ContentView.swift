//
//  ContentView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 05/06/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navState: NavigationState
   @StateObject var authViewModel: AuthViewModel
    @StateObject var businessViewModel: BusinessViewModel
    @StateObject var reviewViewModel: ReviewViewModel
    @StateObject var postViewModel: PostViewModel
    @StateObject var userViewModel: UserViewModel
    @AppStorage("localifyBusinessCreated") var businessCreated: Bool?
    @StateObject var portfolioViewModel: PortfolioViewModel
    @StateObject  var cameraManager = CameraManager()
    @StateObject var logoViewModel: LogoViewModel

    var body: some View {
        NavigationStack(path: $navState.path) {
            VStack { 
                if authViewModel.isLoading {
                       ProgressView()
                }  else if authViewModel.isLoggedIn {
                    if businessCreated != nil {
                        HomeTabView()
                    } else {
                        AddLocationScreen()
                    }
                    
                } else {
                      
                    Home()
                }
              
            }
             
 
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    Login() 
                        .navigationBarBackButtonHidden()
                case .home:
                    Home()
                case .signup:
                    Signup()
                        .navigationBarBackButtonHidden()
                case .welcome:
                    AddLocationScreen()
                        .navigationBarBackButtonHidden()
                case .locationFields:
                    AddLocationFieldsScreen()
                        .navigationBarBackButtonHidden()
                case .businessAddress:
                    AddBusinessAddressView()
                        .navigationBarBackButtonHidden()
                case .aboutBusiness:
                    AboutBusinessView()
                        .navigationBarBackButtonHidden()
                case .tabView:
                    HomeTabView()
                        .navigationBarBackButtonHidden()
                      
                case .chatDetailView(let chat):
                    ChatDetailsView(chat: chat)
                case .postDetailView(let post):
                    SinglePostDetailView(postId: post.id)
            
                }
            }
        }
        .onAppear {
            
            Task {
                
                await authViewModel.getUser()
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(businessViewModel)
        .environmentObject(reviewViewModel)
        .environmentObject(postViewModel)
        .environmentObject(userViewModel)
        .environmentObject(portfolioViewModel)
        .environmentObject(cameraManager)
        .environmentObject(logoViewModel)
            
    }
}


    
    
    
    
    #Preview {
        let navState = NavigationState()
        let mockAuthService = AuthService() // or AuthService()
        let businessService = BusinessService()
        let businessViewModel = BusinessViewModel(businessService: businessService)
        let authViewModel = AuthViewModel(authService: mockAuthService)
        let reviewService = ReviewService()
        let reviewViewModel = ReviewViewModel(reviewService: reviewService)
        
        let postService = PostService()
        let postViewModel = PostViewModel(postService: postService)
        
        let userService = UserService()
        let userViewModel = UserViewModel(userService: userService)
   
        
        let portfolioService = PortfolioService()
        let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
        
        
        let logoService = LogoService()
        let logoViewModel = LogoViewModel(logoService: logoService)
        
        ContentView(authViewModel: authViewModel, businessViewModel: businessViewModel, reviewViewModel: reviewViewModel, postViewModel: postViewModel, userViewModel: userViewModel, portfolioViewModel: portfolioViewModel,
                    logoViewModel: logoViewModel)
            .environmentObject(navState)
       
    }
