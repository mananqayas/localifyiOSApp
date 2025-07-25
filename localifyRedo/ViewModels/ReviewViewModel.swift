//
//  ReviewViewModel.swift
//  localifyRedo
//
//  Created by Manan Qayas on 11/06/2025.
//

import Foundation

@MainActor
class ReviewViewModel: ObservableObject {
    let reviewService: ReviewService
    @Published var isLoading: Bool = false
    @Published var allReviews: [SingleReviewModel] = []
    @Published var rating: Double?
    
    init(reviewService: ReviewService) {
        self.reviewService = reviewService

    }

    func getAllBusinessReviews() async {
        isLoading = true
        let response = await reviewService.getAllReviews()
        
        switch response {
            
        case .success(let response):
            print(response)
            isLoading = false
            self.allReviews = response
        case .failure(let error):
            print(error)
            isLoading = false
        }
    }
    
    func getTotalRatings() async {
        isLoading = true
        let response = await reviewService.getRatingsTotal()
        
        switch response {
            
        case .success(let response):
            
            isLoading = false
            rating = response.averageRating
            print("\(String(describing: rating)) ?? 1.0")
        case .failure(let error):
            print(error)
            isLoading = false
        }
    }
}
