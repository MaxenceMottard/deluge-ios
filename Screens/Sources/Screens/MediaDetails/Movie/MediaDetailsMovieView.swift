//
//  MediaDetailsMovieView.swift
//  Screens
//
//  Created by Maxence Mottard on 29/11/2024.
//

import SwiftUI
import Routing

struct MediaDetailsMovieView: View {
    @State var viewModel: any MediaDetailsMovieViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let viewModel: MediaDetailsMovieViewModel = {
        let viewModel = MockMediaDetailsMovieViewModel()

        return viewModel
    }()

    MediaDetailsMovieView(viewModel: viewModel)
}
