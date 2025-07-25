//
//  DashboardBanner.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI

struct DashboardBanner: View {
    @State private var showEditName: Bool = false
    @State private var showAllPhotos: Bool = false
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @EnvironmentObject var logoViewModel: LogoViewModel
    @State private var showLibraryOption: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showLibrary: Bool = false
    @State private var image: UIImage?
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @State private var showAllReviewSheet: Bool = false
    let businessName: String
    var body: some View {
        if let uploadImage = image {
            Image(uiImage: uploadImage)
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(content: {
                    LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                })
                .overlay {
                    ZStack(alignment: .bottom) {
                        VStack {
                            Spacer()
                            HStack(spacing: 40) {
                                Button {
                                    
                                    print("uploading")
                                    Task {
                                        if let coverUrl = logoViewModel.coverUrl, coverUrl.isEmpty == true {
                                            let response =  await logoViewModel.uploadCover(cover: uploadImage)
                                             if response {
                                                 image = nil
                                                 Task {
                                                     await logoViewModel.getCover()
                                                 }
                                             }
                                        } else {
                                            let response =  await logoViewModel.updateCover(cover: uploadImage)
                                             if response {
                                                 image = nil
                                                 Task {
                                                     await logoViewModel.getCover()
                                                 }
                                             }
                                        }
                                        
                                       
                                    }
                                    
                                } label: {
                                    VStack(spacing: 5) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Upload")
                                    }
                                }
                                .tint(.white)
                                .font(.poppins(.regular, size: 15))
                                Button {
                                    image = nil
                                    showLibrary = true
                                    
                                } label: {
                                    VStack(spacing: 5) {
                                        Image(systemName: "camera")
                                        Text("Retake")
                                    }
                                   
                                }
                                .tint(.white)
                                .font(.poppins(.regular, size: 15))

                            }
                            .padding(.bottom, 20)
                        }
                     
                        
                    }
                }
        } else {
            if let cover = logoViewModel.coverUrl, cover.isEmpty == false {
                ZStack {
                    AsyncImage(url: URL(string: cover)) {phase in
                    
                        switch phase {
                        case .empty:
                            EmptyView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .clipped()
                        case .failure(_):
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.4) ,.black.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .font(.title)
                                .foregroundStyle(.white)
                            
                        }
                        .onTapGesture {
                            showLibraryOption = true
                            print("opening")
                        }
                        .padding()
                        .padding(.top, 30)
                        Spacer()
                        
                    }
                    .zIndex(10)
                    
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(alignment: .center,spacing: 20) {
                                    Text(businessName)
                                        .font(.poppins(.semiBold, size: 26))
                                    
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .onTapGesture {
                                            showEditName.toggle()
                                        }
                                }
                                
                                // reviews
                                HStack(spacing: 20) {
                                    if let rating: Double = reviewViewModel.rating {
                                        let fullStars = Int(rating) // 3
                                        let hasHalfStar = rating - Double(fullStars) >= 0.25 && rating - Double(fullStars) <= 0.75 // true
                                        let halfStars = hasHalfStar ? 1 : 0
                                        let emptyStars = 5 - fullStars - halfStars
                                        HStack(spacing: 10) {
                                            // Full stars
                                            ForEach(0..<fullStars, id: \.self) { _ in
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color.red)
                                                    .frame(width: 20, height: 20)
                                                     .overlay {
                                                     Image(systemName: "star.fill")
                                                      .font(.caption)
                                                         }
                                            }

                                            // Half star (if needed)
                                            if halfStars == 1 {
                                                Image(systemName: "star.leadinghalf.filled")
                                                    .foregroundColor(.yellow)
                                                    .frame(width: 20, height: 20)
                                                    .font(.title2)
                                            }

                                            // Empty stars
                                            ForEach(0..<emptyStars, id: \.self) { _ in
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color.white.opacity(0.3))
                                                
                                                    .frame(width: 20, height: 20)
                                                    .overlay {
                                                        Image(systemName: "star.fill")
                                                            .font(.caption)
                                                    }
                                            }
                                        }
                                    }

                                    Text("\(reviewViewModel.allReviews.count)")

                                }
                                .onTapGesture {
                                    showAllReviewSheet = true
                                }
                            }
                            Spacer()
                            ZStack {
                                Color.white.opacity(0.2)
                                    .frame(width: 110, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                Text("See all \(portfolioViewModel.allPortfolioImages.count)")
                                    .onTapGesture {
                                        showAllPhotos.toggle()
                                    }
                                
                            }
                                
                        }
                        .foregroundStyle(.white)
                        .padding(.bottom, 24)
                        .padding(.horizontal)
                    }
                 
                    
                }
                .onAppear {
                    Task {
                        await logoViewModel.getCover()
                        await reviewViewModel.getAllBusinessReviews()
                        await reviewViewModel.getTotalRatings()
                    }
                }
                .confirmationDialog("Select libary", isPresented: $showLibraryOption, actions: {
                    Button("Select cover from library"){
                        showLibrary = true
                        
                    }
                })
                .sheet(isPresented: $showLibrary, content: {
                    ImagePicker(sourceType: sourceType, selectedImage: $image)
                })
                .sheet(isPresented: $showEditName) {
                    EditBusinessName()
                    
                }
                .fullScreenCover(isPresented: $showAllReviewSheet, content: {
                    ReviewsViewSheet()
                })
                .sheet(isPresented: $showAllPhotos) {
                    SeeAllPhotos()
                }
            } else {
                ZStack {
                    LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white.opacity(0.7))
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .font(.title)
                                
                        }
                        .onTapGesture {
                            showLibraryOption.toggle()
                        }
                        .padding()
                        .padding(.top, 30)
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(businessName)
                                .font(.poppins(.semiBold, size: 26))
                            
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    showEditName.toggle()
                                }
                            Spacer()
                        }
                        // reviews
                        
                        HStack(spacing: 20) {
                            
                            if let rating: Double = reviewViewModel.rating {
                                let fullStars = Int(rating) // 3
                                let hasHalfStar = rating - Double(fullStars) >= 0.25 && rating - Double(fullStars) <= 0.75 // true
                                let halfStars = hasHalfStar ? 1 : 0
                                let emptyStars = 5 - fullStars - halfStars
                                HStack(spacing: 10) {
                                    // Full stars
                                    ForEach(0..<fullStars, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.red)
                                            .frame(width: 20, height: 20)
                                             .overlay {
                                             Image(systemName: "star.fill")
                                              .font(.caption)
                                                 }
                                    }

                                    // Half star (if needed)
                                    if halfStars == 1 {
                                        Image(systemName: "star.leadinghalf.filled")
                                            .foregroundColor(.yellow)
                                            .frame(width: 20, height: 20)
                                            .font(.title2)
                                    }

                                    // Empty stars
                                    ForEach(0..<emptyStars, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white.opacity(0.3))
                                        
                                            .frame(width: 20, height: 20)
                                            .overlay {
                                                Image(systemName: "star.fill")
                                                    .font(.caption)
                                            }
                                    }
                                }

                            }
                            


                            Text("\(reviewViewModel.allReviews.count)")
                            Spacer()
                            ZStack {
                                Color.white.opacity(0.2)
                                    .frame(width: 110, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                Text("See all \(portfolioViewModel.allPortfolioImages.count)")
                                    .onTapGesture {
                                        showAllPhotos.toggle()
                                    }
                                
                            }
                            .padding(.trailing)
                            
                        
                        }
                        .onTapGesture {
                            showAllReviewSheet = true
                        }
                    }
                    .padding(.top, 170)
                    .padding(.leading)
                
                    
                }
                .fullScreenCover(isPresented: $showAllReviewSheet, content: {
                    ReviewsViewSheet()
                })
                .confirmationDialog("Select libary", isPresented: $showLibraryOption, actions: {
                    Button("Select cover from library"){
                        showLibrary = true
                        
                    }
                })
                .onAppear {
                    Task {
                        await logoViewModel.getCover()
                        await reviewViewModel.getAllBusinessReviews()
                        await reviewViewModel.getTotalRatings()
                    }
                }
                .sheet(isPresented: $showLibrary, content: {
                    ImagePicker(sourceType: sourceType, selectedImage: $image)
                })
                .sheet(isPresented: $showEditName) {
                    EditBusinessName()
                    
                }
                .sheet(isPresented: $showAllPhotos) {
                    SeeAllPhotos()
                }
                .frame(height: 300)
                .cornerRadius(10)
            }
        }
 
        
        
    }
    
    
}

#Preview {
    let portfolioService = PortfolioService()
    let portolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    let logoService = LogoService()
    let logoViewModel = LogoViewModel(logoService: logoService)
    let reviewService = ReviewService()
    let reviewViewModel = ReviewViewModel(reviewService: reviewService)
    DashboardBanner(businessName: "TEST")
        .environmentObject(portolioViewModel)
        .environmentObject(logoViewModel)
        .environmentObject(reviewViewModel)
        .frame(height: 200)
}
