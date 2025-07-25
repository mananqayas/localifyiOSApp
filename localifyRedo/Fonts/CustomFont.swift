//
//  CustomFont.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import Foundation
import SwiftUI



enum PoppinsFontWeight: String {
    case extraBold = "Poppins-ExtraBold"
    case extraLight = "Poppins-ExtraLight"
    case italic = "Poppins-Italic"
    case light = "Poppins-Light"
    case bold = "Poppins-Bold"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    
}

extension Font {
    static func poppins(_ weight: PoppinsFontWeight, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
    static func playball(size: CGFloat) -> Font {
        .custom("Playball-Regular", size: size)
    }
}
