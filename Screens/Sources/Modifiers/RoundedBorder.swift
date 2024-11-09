//
//  RoundedBorder.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//


import SwiftUI

struct RoundedBorder: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func roundedBorder(_ color: Color, width: CGFloat, radius: CGFloat) -> some View {
        self.modifier(RoundedBorder(color: color, lineWidth: width, cornerRadius: radius))
    }
}
