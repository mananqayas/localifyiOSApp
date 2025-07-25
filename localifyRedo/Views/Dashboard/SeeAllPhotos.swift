//
//  SeeAllPhotos.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI
struct PortfolioImageSingle: View {
    let image: PortfolioModel
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
        .foregroundStyle(.white)
            .frame(height: 300)
            .overlay {
                ZStack {
                    AsyncImage(url: URL(string: image.url)) {image in
                    image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                          
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                 
                }
              
            }
    }
}
struct SeeAllPhotos: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    let columns = [
        GridItem(.flexible()),
      
    ]

    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding()
                
                Rectangle()
                    .fill(Color.localifyBorderColor)
                    .frame(height: 2)
            }
            if   portfolioViewModel.isLoading {
                ProgressView()
            } else if portfolioViewModel.allPortfolioImages.isEmpty {
                Image("noImagesFound")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text("No images found")
                    .font(.poppins(.medium, size: 26))
                Text("Upload your first image")
                    .font(.poppins(.light, size: 15))
         
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(portfolioViewModel.allPortfolioImages, id: \.id) {image in
                            
                            PortfolioImageSingle(image: image)
                            
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
            }
            
           
            Spacer()
        }
    }
}

#Preview {
    let portfolioService = PortfolioService()
    let portfolioViewModel = PortfolioViewModel(portfolioService: portfolioService)
    SeeAllPhotos()
        .environmentObject(portfolioViewModel)
}
