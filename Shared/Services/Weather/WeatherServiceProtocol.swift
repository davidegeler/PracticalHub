//
//  WeatherServiceProtocol.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
protocol WeatherServiceProtocol {
    func fetchWeather(for cities: [String], on date: Date) async throws -> [CityWeather]
}
