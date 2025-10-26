//
//  OpenMeteoWeatherService.swift
//  PracticalHub
//
//  Created by David Egeler on 26.10.2025.
//


import Foundation

final class OpenMeteoWeatherService: WeatherServiceProtocol {
    // Basel, CH
    private let lat = 47.5584
    private let lon = 7.5733
    private let tz  = "Europe%2FZurich"

    func fetchWeather() async throws -> CityWeather {
        let urlStr = """
        https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&daily=weathercode,temperature_2m_min,temperature_2m_max&timezone=\(tz)
        """
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }

        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }

        let raw = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)

        // --- Mapping -> dein Domain-Model ---
        // Nimm dein CityWeather so wie es bei dir definiert ist.
        // Beispiel: current temp + 3-Tage-forecast (date, min, max, code)
        let days: [CityWeather.Day] = zip(zip(zip(raw.daily.time,
                                                  raw.daily.weathercode),
                                             raw.daily.temperature_2m_min),
                                          raw.daily.temperature_2m_max)
            .compactMap { (t_w, minT, maxT) -> CityWeather.Day? in
                let (t, w) = t_w
                let df = DateFormatter()
                df.locale = .init(identifier: "en_US_POSIX")
                df.dateFormat = "yyyy-MM-dd"
                guard let date = df.date(from: t) else { return nil }
                return .init(date: date, weatherCode: w, tMin: minT, tMax: maxT)
            }

        return CityWeather(
            cityName: "Basel",
            currentTemp: raw.current_weather?.temperature,
            currentCode: raw.current_weather?.weathercode,
            days: Array(days.prefix(5))
        )
    }
}
