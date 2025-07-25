//
//  HomeTabView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject  var navState: NavigationState
    @State private var showCreatePostSheet: Bool  = false
    var body: some View {
        ZStack {
            TabView(selection: $navState.selectedTab) {
                DashboardHome()
   .ignoresSafeArea(.all)
                    .tabItem {
                        Image(navState.selectedTab == 0 ? "home-active" : "home")
                        Text("Home")
                    }
                    .tag(0)

                PostsHome()
                    .tabItem {
                        Image(navState.selectedTab == 1 ? "posts-active" : "posts")
                        Text("Posts")
                    }
                    .tag(1)

                PortfolioHome()
                    .tabItem {
                        Image(navState.selectedTab == 2 ? "portfolio-active" : "portfolio")
                        Text("Portfolio")
                    }
                    .tag(2)

                MessagesHome()
                    .tabItem {
                        Image(navState.selectedTab == 3 ? "messages-active" : "messages")
                        Text("Messages")
                    }
                    .tag(3)

                ProfileHome()
                    .tabItem {
                        Image(navState.selectedTab == 4 ? "profile-active" : "profile")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .sheet(isPresented: $showCreatePostSheet, content: {
                CreateNewPostView()
            })

            .tint(.red)
        }
    }
}

#Preview {
    let authService = AuthService()
    let navState = NavigationState()
    let authViewModel = AuthViewModel(authService: authService)
    let businessService = BusinessService()
    let businessViewModel = BusinessViewModel(businessService: businessService)
    let postService = PostService()
    let postViewModel = PostViewModel(postService: postService)
    let userService = UserService()
    let userViewModel = UserViewModel(userService: userService)
    
    let portfolioService = PortfolioService()
    let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    HomeTabView()
        .environmentObject(authViewModel)
        .environmentObject(navState)
        .environmentObject(businessViewModel)
        .environmentObject(postViewModel)
        .environmentObject(userViewModel)
        .environmentObject(portfolioViewModel)
}
