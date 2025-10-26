//
//  DailyViewModel.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//

import Foundation
import Combine

@MainActor
final class DailyViewModel: ObservableObject {

    // MARK: - Published States
    @Published private(set) var snapshot: DailySnapshot
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Wetter-Properties
    @Published var cityWeather: CityWeather?
    @Published var isLoadingWeather = false
    @Published var weatherError: String?

    // MARK: - Dependencies
    private let calendarService: CalendarServiceProtocol
    private let tasksService: TasksServiceProtocol
    private let weatherService: WeatherServiceProtocol

    // MARK: - Init
    init(
        date: Date = Date(),
        calendarService: CalendarServiceProtocol = MockCalendarService(),
        tasksService: TasksServiceProtocol = MockTasksService(),
        weatherService: WeatherServiceProtocol = OpenMeteoWeatherService()
    ) {
        self.calendarService = calendarService
        self.tasksService = tasksService
        self.weatherService = weatherService

        // optionales Testdatum – hier z. B. Samstag
        let testDate = Self.makeDate(weekday: 6)
        self.snapshot = DailySnapshot(
            date: testDate,
            hasGym: false, training: nil,
            hasSchool: false, isOfficeDay: false, isSpaDay: false,
            links: [], weather: [], tasks: []
        )
    }

    // MARK: - Wetter laden (Basel)
    func loadWeather() async {
        guard !isLoadingWeather else { return }
        isLoadingWeather = true
        weatherError = nil
        do {
            self.cityWeather = try await weatherService.getWeather(for: "Basel")
        } catch {
            self.weatherError = (error as NSError).localizedDescription
        }
        isLoadingWeather = false
    }

    // MARK: - Snapshot laden (bestehende Logik)
    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            async let tasks = tasksService.loadTasks(for: snapshot.date)
            let rules = Self.rules(for: snapshot.date)
            let tasksList = try await tasks

            snapshot.hasGym = rules.hasGym
            snapshot.training = rules.training
            snapshot.hasSchool = rules.hasSchool
            snapshot.isOfficeDay = rules.isOfficeDay
            snapshot.isSpaDay = rules.isSpaDay
            snapshot.links = rules.links
            snapshot.weather = []          // Wetter-Infos separat via loadWeather()
            snapshot.tasks = tasksList
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleTask(_ task: DailyTask) {
        guard let idx = snapshot.tasks.firstIndex(of: task) else { return }
        snapshot.tasks[idx].isDone.toggle()
    }
}

// MARK: - Weekday rules
extension DailyViewModel {

    struct DayRules {
        var hasGym: Bool
        var training: TrainingSessionType?
        var hasSchool: Bool
        var isOfficeDay: Bool
        var isSpaDay: Bool
        var links: [ExternalLink]
        var weatherCities: [String]
    }

    static func makeDate(weekday: Int) -> Date {
        var comps = DateComponents()
        comps.weekday = weekday  // 1 = Sonntag, 2 = Montag, … 7 = Samstag
        comps.weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
        comps.yearForWeekOfYear = Calendar.current.component(.yearForWeekOfYear, from: Date())
        return Calendar.current.date(from: comps) ?? Date()
    }

    static func rules(for date: Date) -> DayRules {
        let wd = Calendar.current.component(.weekday, from: date)
        switch wd {
        case 2:
            return .init(hasGym: true, training: .upperBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [ExternalLink(title: "BrandsForEmployees",
                                              urlString: "https://brandsforemployees.com")],
                         weatherCities: ["Basel"])
        case 3:
            return .init(hasGym: false, training: .rest, hasSchool: true,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 4:
            return .init(hasGym: true, training: .lowerBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 5:
            return .init(hasGym: false, training: .rest, hasSchool: true,
                         isOfficeDay: true, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 6:
            return .init(hasGym: true, training: .upperBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 7:
            return .init(hasGym: true, training: .lowerBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        default:
            return .init(hasGym: false, training: .rest, hasSchool: false,
                         isOfficeDay: false, isSpaDay: true,
                         links: [], weatherCities: ["Basel"])
        }
    }
}
