//
//  DailyTask.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

struct DailyTask: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    init(id: UUID = UUID(), title: String, isDone: Bool = false) {
        self.id = id; self.title = title; self.isDone = isDone
    }
}
