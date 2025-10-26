//
//  WeatherServiceProtocol.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//
import Foundation

protocol WeatherServiceProtocol {
    func getWeather(for city: String) async throws -> CityWeather
}
