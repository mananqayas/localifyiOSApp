//
//  ReviewSingleCard.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

import SwiftUI

func formatISODateString(_ isoString: String) -> String? {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: isoString) else {
        return nil
    }
    
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "dd/MM/yy"
    displayFormatter.timeZone = TimeZone.current // Change if you want a specific timezone
    
    return displayFormatter.string(from: date)
}

struct ReviewSingleCard: View {
    let review: SingleReviewModel
    @State private var comment: String = ""
    @State private var showCommentField: Bool = false
    @State private var rating: Int = 0
    


    

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // top
            
            HStack(spacing: 20) {
                let firstInitial = review.user.fName.first.map { String($0) } ?? ""
                let lastInitial = review.user.lName.first.map { String($0) } ?? ""
           
                Circle()
                    .frame(width: 60)
                    .foregroundStyle(Color.gray.opacity(0.2))
                    .overlay {
                        Text("\(firstInitial)\(lastInitial)")
                            .font(.poppins(.medium, size: 17))
                    }
                
                VStack(alignment: .leading, spacing: 5) {
                    let firstName = review.user.fName
                    let lastInitial = review.user.lName.first.map { String($0) } ?? ""
                    Text("\(firstName) \(lastInitial).")
                        .font(.poppins(.semiBold, size: 16))
                    HStack(spacing: 20) {
                        ReviewStars(starCount: review.rating)
                        Text(formatISODateString(review.createdAt) ?? "")
                            .font(.poppins(.regular, size: 16))
                            .foregroundStyle(Color.localifyGray)
                    }
                }
            }
            
            // feedback
            Text(review.comment)
                .font(.poppins(.light, size: 15))
                .foregroundStyle(Color.localifyGray)
            
            // comment
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: 80, height: 20)
                    .overlay {
                        Text("Comment")
                            .font(.poppins(.light, size: 12))
                    }
                    .onTapGesture {
                        showCommentField.toggle()
                    }

                Spacer()
            }
            if showCommentField {
                ReviewComment(text: $comment, placeholder: "Enter your comment")
                    .animation(.easeInOut(duration: 0.5), value: showCommentField)
                 
              
            }
            Divider()


        }

    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            ReviewSingleCard(review: .init(id: UUID().uuidString, rating: 4, comment: "Nice", createdAt: "2025-06-11T05:54:07.079Z", user: .init(fName: "Manan", lName: "Qayas")))
          
        }
        .scrollIndicators(.hidden)
   
    }
    .padding()
}

struct ReviewComment: View {
    @Binding var text: String
    var placeholder: String
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            .background(Color.white)
   
            .overlay {
                ZStack {
                    TextEditor(text: $text)
                        .padding(8)
                        .font(.body)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "paperplane")
                                .padding()
                                .onTapGesture {
                                    print("sending message")
                                }
                        }
                    }
                }
                    
            }
            .frame(height: 100)
         
           
    }

}
