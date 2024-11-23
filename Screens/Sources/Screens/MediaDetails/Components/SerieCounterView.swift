//
//  SerieCounterView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI
import Workers

struct SerieCounterView: View {
    let season: Serie.Season
    let status: SeasonStatus

    private var color: Color {
        switch status {
        case .completed: .green
        case .missingMonitored: .red
        case .missingNonMonitored: .orange
        }
    }

    var body: some View {
        Text("\(season.episodeFileCount) / \(season.episodeCount)")
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(color)
            .cornerRadius(8)
    }
}

#Preview {
    SerieCounterView(season: .preview(), status: .completed)
    SerieCounterView(season: .preview(), status: .missingMonitored)
    SerieCounterView(season: .preview(), status: .missingNonMonitored)
}
