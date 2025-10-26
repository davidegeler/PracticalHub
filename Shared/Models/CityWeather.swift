//
//  CityWeather.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

struct CityWeather {
    struct Day: Identifiable, Equatable {
        let id = UUID()
        let date: Date
        let weatherCode: Int
        let tMin: Double
        let tMax: Double
    }

    let cityName: String
    let currentTemp: Double?
    let currentCode: Int?
    let days: [Day]
}
