//
//  CityWeather.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
struct CityWeather: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    var city: String
    var summary: String // Placeholder, echte API später
}
