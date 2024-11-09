//
//  ReadSizeModifier.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//


import SwiftUI

extension View {
    public func readSize(_ size: Binding<CGSize>) -> some View {
        modifier(ReadSizeModifier(size: size))
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            DispatchQueue.main.async {
                onChange(size)
            }
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct ReadSizeModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .readSize(onChange: { newSize in
                size = newSize
            })
    }
}
