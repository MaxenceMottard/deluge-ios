//
//  File.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import SwiftUI
import Utils

struct InstanceWrapperView<Content: View>: View {
    @State private var instanceWorker: InstanceWorking = Dependency.resolve(InstanceWorking.self)!
    var content: () -> Content

    var body: some View {
        content()
            .id(instanceWorker.selectedInstance?.id)
    }
}
