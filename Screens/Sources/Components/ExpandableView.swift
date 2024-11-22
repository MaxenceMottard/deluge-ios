//
//  ExpandableView.swift
//  Screens
//
//  Created by Maxence Mottard on 22/11/2024.
//

import SwiftUI

struct ExpandableView<H: View, C: View>: View {
    @State private var isExpanded: Bool = false

    let header: () -> H
    let content: () -> C

    var body: some View {
        ContainerView {
            VStack(spacing: 0) {
                HStack {
                    header()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                        .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

                if isExpanded {
                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                }
            }
            .padding()
        }
    }
}
