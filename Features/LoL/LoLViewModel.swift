//
//  LoLViewModel.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
import Combine


@MainActor
final class LoLViewModel: ObservableObject {
    @Published var summonerName: String = ""
    @Published var status: String = "Gib einen Summoner ein"
    private let riot = RiotAPIClient.shared

    func search() async {
        guard !summonerName.isEmpty else { return }
        do {
            _ = try await riot.fetchSummoner(byName: summonerName, region: .euw1)
            status = "Gefunden! (Details folgen)"
        } catch {
            status = "Fehler: \(error.localizedDescription)"
        }
    }
}
