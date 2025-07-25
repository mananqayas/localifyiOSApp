//
//  DashboardHome.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct DashboardHome: View {
    @State private var showReviews: Bool = false
    @State private var editLogo: Bool = false
    @EnvironmentObject private var businessViewModel: BusinessViewModel
    @State private var showAddNewPortfolioImageSheet: Bool = false
    @State private var isPressed = false
    @EnvironmentObject var cameraManager: CameraManager
    @EnvironmentObject var logoViewModel: LogoViewModel
    var body: some View {
        ScrollView {
           if businessViewModel.isLoadingBusiness {
               ProgressView()
           } else {
               VStack(alignment: .leading, spacing: 16) {
                   
                   DashboardBanner(businessName: businessViewModel.businessData?.business.name ?? "")
                   
                   // 3 icons
                   VStack(spacing: 0) {
                       // row of 3 icons
                       HStack(spacing: 30) {
                           Spacer()
                           IconAndTitleView(icon: "camera", text: "Add photo")
                               .scaleEffect(isPressed ? 0.85 : 1.0)
                               .animation(.easeInOut(duration: 0.2), value: isPressed)
                           
                               .gesture(
                                
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ _ in
                                        isPressed = true
                                    })
                                    .onEnded({ _ in
                                        isPressed = false
                                        cameraManager.startSession()
                                        showAddNewPortfolioImageSheet = true
                                    })
                               )
                           IconAndTitleView(icon: "review", text: "See reviews")
                               .onTapGesture {
                                   showReviews.toggle()
                               }
                           if logoViewModel.logoUrl?.isEmpty == false {
                               if let url = logoViewModel.logoUrl {
                                   AsyncImage(url: URL(string: url)) {phase in
                                   
                                       switch phase {
                                       case .empty:
                                           EmptyView()
                                       case .success(let image):
                                           VStack(spacing: 20) {
                                               image
                                                   .resizable()
                                                   .scaledToFit()
                                                   .clipShape(Circle())
                                                   .frame(width: 50)
                                               Text("Edit Logo")
                                                   .foregroundStyle(Color(red: 100/255, green: 99/255, blue: 99/255))
                                                   .font(.poppins(.regular, size: 14))
                                           }
                                           .onTapGesture {
                                               editLogo.toggle()
                                           }
                                       case .failure(_):
                                           EmptyView()
                                       @unknown default:
                                           EmptyView()
                                       }
                                       
                                   }
                               }
                           } else {
                               IconAndTitleView(icon: "editlogo", text: "Edit Logo")
                                   .onTapGesture {
                                       editLogo.toggle()
                                   }
                           }
                        
                           
                         
                          
                           Spacer()
                       }
                       .fullScreenCover(isPresented: $showAddNewPortfolioImageSheet, content: {
                           AddNewPortfolioImageSheet()
                       })
                       .padding(.vertical, 26)

                       // Bottom border
                       Rectangle()
                           .frame(height: 10)
                           .foregroundColor(Color(red: 242/255, green: 242/255, blue: 242/255)) // customize color
                   }
                   .onAppear {
                       Task {
                           await logoViewModel.fetchLogo()
                       }
                   }
                   
                   // about
                   VStack {
                       HomeAboutBusinessView()
                           .padding(.horizontal)
                           .padding(.bottom, 20)
                    
                       
                       // Bottom border
                       Rectangle()
                           .frame(height: 10)
                           .foregroundColor(Color(red: 242/255, green: 242/255, blue: 242/255)) // customize color
                   }
                   
                   // categories and services
                   VStack {
                       BusinessServicesView()
                           .padding(.horizontal)
                           .padding(.bottom, 20)
                       // Bottom border
                       Rectangle()
                           .frame(height: 10)
                           .foregroundColor(Color(red: 242/255, green: 242/255, blue: 242/255)) // customize color
                   }
                   .padding(.bottom, 150)
                   
               }}
           }
         
        .onAppear {
         
            Task {
                
                await businessViewModel.getBusinessData()
                await businessViewModel.getBusinessServices()
            }
        }
        .scrollIndicators(.hidden)
        .fullScreenCover(isPresented: $showReviews, content: {
            ReviewsViewSheet()
        })
        .fullScreenCover(isPresented: $editLogo, content: {
            EditLogoView()
        })
        
    }
}

#Preview {
    let authService = AuthService()
    let businessService = BusinessService()
    let authViewModel = AuthViewModel(authService: authService)
    let businessViewModel = BusinessViewModel(businessService: businessService )
    let portfolioService = PortfolioService()
    let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    let cameraManager = CameraManager()
    let logoService = LogoService()
    let logoViewModel = LogoViewModel(logoService: logoService)
    DashboardHome()
        .environmentObject(authViewModel)
        .environmentObject(businessViewModel)
        .environmentObject(portfolioViewModel)
        .environmentObject(cameraManager)
        .environmentObject(logoViewModel)
}
