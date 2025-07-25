//
//  NavHeader.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import SwiftUI

struct NavHeader: View {
    let title: String
    @EnvironmentObject var navState: NavigationState
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .top) {
                HStack {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundStyle(Color.localifyGray)
                    .font(.poppins(.regular, size: 16))
                    
                        .onTapGesture {
                            navState.path.removeLast()
                        }
                
                    Spacer()
                }
                HStack {
                    Text(title)
                        .foregroundStyle(Color.localifyGray)
                        .font(.poppins(.regular, size: 16))
                }
            }
            .padding(.horizontal)
            Rectangle()
                .foregroundStyle(Color.localifyBorderColor)
                .frame(height: 1)
            
        }
    }
}

#Preview {
    NavHeader(title: "Sign up")
}
