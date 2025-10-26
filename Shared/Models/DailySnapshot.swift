//
//  DailySnapshot.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

/// Tages-Zusammenfassung für die Daily-Page.
/// Keine Codable-Konformität nötig (wir persistieren das aktuell nicht).
struct DailySnapshot: Equatable {
    var date: Date

    // Tages-Flags
    var hasGym: Bool
    var training: TrainingSessionType?   // .upperBody / .lowerBody / .rest

    var hasSchool: Bool
    var isOfficeDay: Bool
    var isSpaDay: Bool

    // Sonstiges
    var links: [ExternalLink]
    /// Optional: Platzhalter für evtl. Wetterdaten auf Snapshot-Ebene
    /// (die echte Wetteranzeige nutzt `DailyViewModel.cityWeather`)
    var weather: [CityWeather.Day]

    var tasks: [DailyTask]
}

