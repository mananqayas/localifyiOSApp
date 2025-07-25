//
//  ReviewsViewSheet.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI


import SwiftUI

struct ReviewsViewSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var reviewViewModel: ReviewViewModel
    

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Text("Reviews")
                        .font(.headline)
                }

                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .padding()
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3)),
                alignment: .bottom
            )
            ScrollView {
                if reviewViewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if reviewViewModel.allReviews.isEmpty {
                    HStack {
                        Spacer()
                        Image("noReviewsPlaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        
                     
                        Spacer()
                    }
                    
                    VStack {
                        Text("No reviews yet")
                            .font(.poppins(.medium, size: 25))
                        Text("Check later which your customers will leave reviews")
                            .font(.poppins(.light, size: 15))
                            .foregroundStyle(Color.localifyGray)
                        
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                } else {
                    VStack(spacing: 20) {
                        Rectangle()
                            .frame(height: 4)
                            .foregroundStyle(Color.clear)
                        
                        
                        
                        ForEach(reviewViewModel.allReviews) {review in
                            ReviewSingleCard(review: review)
                        }
                 
                     
                    }
                    .padding()
                }
              
            
                
            }
            .onAppear {
                Task {
                    
                    await reviewViewModel.getAllBusinessReviews()
                }
            }
            .scrollIndicators(.hidden)
         
            Spacer()
        }
    
    }
}

#Preview {
    let reviewService = ReviewService()
    let reviewViewModel = ReviewViewModel(reviewService: reviewService)
    ReviewsViewSheet()
        .environmentObject(reviewViewModel)
}
