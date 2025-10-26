//
//  MockTasksService.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
final class MockTasksService: TasksServiceProtocol {
    func loadTasks(for date: Date) async throws -> [DailyTask] {
        [DailyTask(title: "2L Wasser trinken"),
         DailyTask(title: "8k Schritte"),
         DailyTask(title: "30 min Lernen")]
    }
}
