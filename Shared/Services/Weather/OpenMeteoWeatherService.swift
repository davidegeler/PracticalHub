//
//  OpenMeteoWeatherService.swift
//  PracticalHub
//
//  Created by David Egeler on 26.10.2025.
//
import Foundation

final class OpenMeteoWeatherService: WeatherServiceProtocol {
    private let lat = 47.5584
    private let lon = 7.5733
    private let tz  = "Europe%2FZurich"

    func getWeather(for city: String) async throws -> CityWeather {
        let urlStr = """
        https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&daily=weathercode,temperature_2m_min,temperature_2m_max&timezone=\(tz)
        """
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }

        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }

        let raw = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

        let df = DateFormatter()
        df.locale = .init(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"

        var days: [CityWeather.Day] = []
        for i in 0..<raw.daily.time.count {
            guard
                let d = df.date(from: raw.daily.time[i]),
                i < raw.daily.weathercode.count,
                i < raw.daily.temperature_2m_min.count,
                i < raw.daily.temperature_2m_max.count
            else { continue }

            days.append(.init(
                date: d,
                weatherCode: raw.daily.weathercode[i],
                tMin: raw.daily.temperature_2m_min[i],
                tMax: raw.daily.temperature_2m_max[i]
            ))
        }

        return CityWeather(
            cityName: "Basel",
            currentTemp: raw.current_weather?.temperature,
            currentCode: raw.current_weather?.weathercode,
            days: Array(days.prefix(5))
        )
    }
}
