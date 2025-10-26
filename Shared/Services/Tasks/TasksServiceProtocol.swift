//
//  TasksServiceProtocol.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
protocol TasksServiceProtocol {
    func loadTasks(for date: Date) async throws -> [DailyTask]
}
