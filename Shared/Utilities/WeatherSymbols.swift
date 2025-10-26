//
//  WeatherSymbols.swift
//  PracticalHub
//
//  Created by David Egeler on 26.10.2025.
//
import Foundation

enum WeatherSymbols {
    static func name(for code: Int, isDay: Bool = true) -> String {
        switch code {
        case 0:                 return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1, 2:              return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 3:                 return "cloud.fill"
        case 45, 48:            return "cloud.fog.fill"
        case 51, 53, 55:        return "cloud.drizzle.fill"
        case 56, 57:            return "cloud.sleet.fill"
        case 61, 63:            return "cloud.rain.fill"
        case 65, 80, 81, 82:    return "cloud.heavyrain.fill"
        case 66, 67:            return "cloud.hail.fill"
        case 71, 73:            return "cloud.snow.fill"
        case 75, 85, 86:        return "snowflake"
        case 77:                return "cloud.snow"
        case 95:                return "cloud.bolt.rain.fill"
        case 96, 99:            return "cloud.hail"
        default:                return "questionmark.circle"
        }
    }
}

