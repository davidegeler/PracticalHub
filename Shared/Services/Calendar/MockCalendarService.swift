//
//  MockCalendarService.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
final class MockCalendarService: CalendarServiceProtocol {
    func hasSchool(on date: Date) async throws -> Bool { false }
}
