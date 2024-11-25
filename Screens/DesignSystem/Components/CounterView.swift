//
//  SerieCounterView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct CounterView: View {
    private let leftValue: String
    private let rightValue: String
    private let status: Status

    public init(leftValue: String, rightValue: String, status: Status) {
        self.leftValue = leftValue
        self.rightValue = rightValue
        self.status = status
    }

    private var color: Color {
        switch status {
        case .success: .green
        case .error: .red
        case .warning: .orange
        case .neutral: .blue
        }
    }

    public var body: some View {
        Text("\(leftValue) / \(rightValue)")
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(color)
            .cornerRadius(8)
    }

    public enum Status {
        case success
        case error
        case warning
        case neutral
    }
}

#Preview {
    ForEach(CounterView.Status.allCases, id: \.self) { status in
        CounterView(leftValue: "20", rightValue: "50", status: status)
    }
}

extension CounterView.Status: CaseIterable {}
