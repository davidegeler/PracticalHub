//
//  DailySnapshot.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

struct DailySnapshot: Equatable, Codable {
    var date: Date
    var hasGym: Bool
    var training: TrainingSessionType?
    var hasSchool: Bool
    var isOfficeDay: Bool
    var isSpaDay: Bool
    var links: [ExternalLink]
    var weather: [CityWeather]
    var tasks: [DailyTask]
}
