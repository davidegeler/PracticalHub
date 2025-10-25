//
//  DailyView.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import SwiftUI

struct DailyView: View {
    @StateObject var viewModel: DailyViewModel
    var body: some View {
        NavigationStack {
            List {
                Section("Heute") {
                    Toggle("Gym heute?", isOn: $viewModel.shouldGym)
                    LabeledContent("Training", value: viewModel.gymPlan)
                    LabeledContent("Schule heute", value: viewModel.schoolToday ? "Ja" : "Nein")
                }
            }
            .navigationTitle("Daily")
        }
    }
}
