//
//  File.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import SwiftUI
import Utils

struct InstanceWrapperView<Content: View>: View {
    @State private var instanceRepository: InstanceRepository = Dependency.resolve(InstanceRepository.self)!
    var content: () -> Content

    var body: some View {
        content()
            .id(instanceRepository.selectedInstance?.id)
    }
}
