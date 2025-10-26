//
//  OpenMeteoDTO.swift
//  PracticalHub
//
//  Created by David Egeler on 26.10.2025.
//
import Foundation

struct OpenMeteoResponse: Decodable {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let weathercode: Int
    }
    struct Daily: Decodable {
        let time: [String]
        let weathercode: [Int]
        let temperature_2m_min: [Double]
        let temperature_2m_max: [Double]
    }
    let current_weather: CurrentWeather?
    let daily: Daily
}



