//
//  TrainingSessionType.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

enum TrainingSessionType: String, CaseIterable, Codable, Identifiable {
    case upperBody = "Oberkörper"
    case lowerBody = "Unterkörper"
    case cardio = "Cardio"
    case rest = "Rest"
    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .upperBody: return "💪"
        case .lowerBody: return "🦵"
        case .cardio: return "🏃‍♀️"
        case .rest: return "🛌"
        }
    }
}
