//
//  ItemAndTitleView.swift
//  localifyRedo
//
//  Created by Manan Qayas on 09/06/2025.
//

import SwiftUI

struct IconAndTitleView: View {
    let icon: String
    let text: String
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .frame(width: 50)
                    .foregroundStyle(.gray.opacity(0.2))
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            Text(text)
                .foregroundStyle(Color(red: 100/255, green: 99/255, blue: 99/255))
                .font(.poppins(.regular, size: 14))
        }
    }
}

#Preview {
    HStack(spacing: 30) {
        IconAndTitleView(icon: "camera", text: "Add Photo")
        IconAndTitleView(icon: "camera", text: "Add Photo")
        IconAndTitleView(icon: "editlogo", text: "Add Photo")

    }
}
