//
//  ReadSizeModifier.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//


import SwiftUI

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct OnSizeModifier: ViewModifier {
    let onChange: (CGSize) -> Void

    init(onChange: @escaping (CGSize) -> Void) {
        self.onChange = onChange
    }

    func body(content: Content) -> some View {
        content
            .background(
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

private struct ReadSizeModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .modifier(OnSizeModifier {
                size = $0
            })
    }
}

public extension View {
    nonisolated func readSize(_ size: Binding<CGSize>) -> some View {
        modifier(ReadSizeModifier(size: size))
    }

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        modifier(OnSizeModifier(onChange: onChange))
    }
}
