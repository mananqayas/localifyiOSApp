//
//  CustomButtonStyle.swift
//  localifyRedo
//
//  Created by Manan Qayas on 08/06/2025.
//

import Foundation
import SwiftUI
struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(configuration.isPressed ? Color.localifyRed.opacity(0.7) : Color.localifyRed)
            .frame(height: 50)
            .opacity(isEnabled ? 1.0 : 0.5)
            .overlay {
                configuration.label
                    .font(.poppins(.semiBold, size: 15))
                    .foregroundStyle(.white)
            }
  
    }}
