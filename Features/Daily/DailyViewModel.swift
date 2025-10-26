//
//  DailyViewModel.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
import Combine

final class DailyViewModel: ObservableObject {
    @Published private(set) var snapshot: DailySnapshot
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let calendarService: CalendarServiceProtocol
    private let tasksService: TasksServiceProtocol
    private let weatherService: WeatherServiceProtocol

    /*    init(
        date: Date = Date(),
        calendarService: CalendarServiceProtocol = MockCalendarService(),
        tasksService: TasksServiceProtocol = MockTasksService(),
        weatherService: WeatherServiceProtocol = OpenMeteoWeatherService()
    ) {
        self.calendarService = calendarService
        self.tasksService = tasksService
        self.weatherService = weatherService
        self.snapshot = DailySnapshot(
            date: date, hasGym: false, training: nil,
            hasSchool: false, isOfficeDay: false, isSpaDay: false,
            links: [], weather: [], tasks: []
        )
    }*/
    init(
        date: Date = Date(), // hier Standardwert ändern
        calendarService: CalendarServiceProtocol = MockCalendarService(),
        tasksService: TasksServiceProtocol = MockTasksService(),
        weatherService: WeatherServiceProtocol = OpenMeteoWeatherService()
    ) {
        self.calendarService = calendarService
        self.tasksService = tasksService
        self.weatherService = weatherService

        // HIER: manuelles Testdatum setzen 👇
        let testDate = Self.makeDate(weekday: 6) // 2 = Montag
        self.snapshot = DailySnapshot(
            date: testDate,
            hasGym: false, training: nil,
            hasSchool: false, isOfficeDay: false, isSpaDay: false,
            links: [], weather: [], tasks: []
        )
    }


    @MainActor
    func load() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            async let tasks = tasksService.loadTasks(for: snapshot.date)
            let rules = Self.rules(for: snapshot.date)
            async let weather = weatherService.fetchWeather(for: rules.weatherCities, on: snapshot.date)
            let (tasksList, weatherList) = try await (tasks, weather)

            snapshot.hasGym = rules.hasGym
            snapshot.training = rules.training
            snapshot.hasSchool = rules.hasSchool
            snapshot.isOfficeDay = rules.isOfficeDay
            snapshot.isSpaDay = rules.isSpaDay
            snapshot.links = rules.links
            snapshot.weather = weatherList
            snapshot.tasks = tasksList
        } catch { errorMessage = error.localizedDescription }
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
    // Test Func for Day manipulation
    static func makeDate(weekday: Int) -> Date {
            var comps = DateComponents()
            comps.weekday = weekday  // 1=Sonntag, 2=Montag, …7=Samstag
            comps.weekOfYear = Calendar.current.component(.weekOfYear, from: Date())
            comps.yearForWeekOfYear = Calendar.current.component(.yearForWeekOfYear, from: Date())
            return Calendar.current.date(from: comps) ?? Date()
        }

    static func rules(for date: Date) -> DayRules {
        let wd = Calendar.current.component(.weekday, from: date) // 1=So, 2=Mo,...7=Sa
        switch wd {
        case 2: // Montag
            return .init(hasGym: true, training: .upperBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [ExternalLink(title: "BrandsForEmployees", urlString: "https://brandsforemployees.com")],
                         weatherCities: ["Basel"])
        case 3: // Dienstag
            return .init(hasGym: false, training: .rest, hasSchool: true,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel","Zürich"])
        case 4: // Mittwoch
            return .init(hasGym: true, training: .lowerBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 5: // Donnerstag
            return .init(hasGym: false, training: .rest, hasSchool: true,
                         isOfficeDay: true, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 6: // Freitag
            return .init(hasGym: true, training: .upperBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        case 7: // Samstag
            return .init(hasGym: true, training: .lowerBody, hasSchool: false,
                         isOfficeDay: false, isSpaDay: false,
                         links: [], weatherCities: ["Basel"])
        default: // Sonntag
            return .init(hasGym: false, training: .rest, hasSchool: false,
                         isOfficeDay: false, isSpaDay: true, // Spa Day
                         links: [], weatherCities: ["Basel"])
        }
    }
}

