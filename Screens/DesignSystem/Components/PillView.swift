//
//  SerieCounterView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct PillView: View {
    private let value: String
    private let status: Status

    public init(value: String, status: Status) {
        self.value = value
        self.status = status
    }

    private var color: Color {
        switch status {
        case .success: .green
        case .error: .red
        case .warning: .orange
        case .info: .blue
        case .queued: .purple
        }
    }

    public var body: some View {
        Text(value)
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(color)
            .cornerRadius(8)
    }

    public enum Status {
        case success
        case error
        case warning
        case info
        case queued
    }
}

#Preview {
    ForEach(PillView.Status.allCases, id: \.self) { status in
        PillView(value: "20 / 200", status: status)
    }
}

extension PillView.Status: CaseIterable {}
