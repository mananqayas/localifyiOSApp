//
//  Toast.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import SwiftUI



struct RoundedCornerShape: Shape {
    var radius: CGFloat = 16
    var corners: UIRectCorner = [.topLeft, .bottomLeft]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
struct Toast: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 110)
            .foregroundStyle(.white)
            .shadow(color: .localifyGray.opacity(0.1), radius: 10, x: 10, y: 10)
            .overlay {
                HStack(spacing: 40) {
                    Rectangle()
                        .fill(Color(red: 0, green: 128/255, blue: 0))
                        .frame(width: 15)
                        .clipShape(RoundedCornerShape(radius: 20, corners: [.topLeft, .bottomLeft]) )
                
                    HStack(spacing: 14) {
                        Image(systemName: "checkmark.circle")
                            .font(.title)
                            .foregroundStyle(Color(red: 0, green: 128/255, blue: 0))
                        VStack(alignment: .leading) {
                            Text("Congratulations")
                                .font(.poppins(.medium, size: 16))
                            Text("Your account has been successfully created.")
                                .font(.poppins(.light, size: 14))
                                .foregroundStyle(Color(red: 51/255, green: 51/255, blue: 51/255))
                        }
                    }
                    Spacer()
                }
            }
    }
}

#Preview {
    Toast()
        .padding()
}
