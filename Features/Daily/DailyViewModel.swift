//
//  DailyViewModel.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
import Combine


final class DailyViewModel: ObservableObject {
    @Published var shouldGym: Bool = false
    @Published var gymPlan: String = "Rest"
    @Published var schoolToday: Bool = false
}
