//
//  LoLView.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import SwiftUI

struct LoLView: View {
    @StateObject var viewModel: LoLViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("Summoner Name", text: $viewModel.summonerName)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                Button("Suchen") { Task { await viewModel.search() } }
                Text(viewModel.status).foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("League of Legends")
        }
    }
}
