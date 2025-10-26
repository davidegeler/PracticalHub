//
//  MockWeatherService.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
final class MockWeatherService: WeatherServiceProtocol {
    func fetchWeather(for cities: [String], on date: Date) async throws -> [CityWeather] {
        cities.map { CityWeather(city: $0, summary: "—°C, später echt") }
    }
}
