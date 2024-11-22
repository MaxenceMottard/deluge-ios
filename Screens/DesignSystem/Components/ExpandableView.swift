//
//  ExpandableView.swift
//  Screens
//
//  Created by Maxence Mottard on 22/11/2024.
//

import SwiftUI

public struct ExpandableView<H: View, C: View>: View {
    @State private var isExpanded: Bool = false

    let showChevron: Bool
    let header: () -> H
    let content: () -> C

    public init(showChevron: Bool = true, header: @escaping () -> H, content: @escaping () -> C) {
        self.showChevron = showChevron
        self.header = header
        self.content = content
    }

    public var body: some View {
        ContainerView {
            VStack(spacing: 0) {
                HStack {
                    header()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if showChevron {
                        Image(systemName: "chevron.down")
                            .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

                if isExpanded {
                    Divider()
                        .padding(.vertical, 20)

                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ExpandableView {
        Text("The header")
    } content: {
        VStack {
            Text("Content 1")
            Text("Content 2")
            Text("Content 3")
        }
    }

    ExpandableView(showChevron: false) {
        Text("The header")
    } content: {
        VStack {
            Text("Content 1")
            Text("Content 2")
            Text("Content 3")
        }
    }
}
