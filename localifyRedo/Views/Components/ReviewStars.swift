//
//  ReviewStars.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

import SwiftUI

struct ReviewStars: View {
    let starCount: Int
    var body: some View {
        HStack {
            
            ForEach(1...5, id: \.self) {index in
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(index <= starCount ? .red : Color.gray.opacity(0.5))
                
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
            }
        }
    }
}

#Preview {
    ReviewStars(starCount: 1)
        .padding()
}
