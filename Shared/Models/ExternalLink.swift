//
//  ExternalLink.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation
struct ExternalLink: Identifiable, Codable, Hashable {
    let id: UUID = UUID()
    var title: String
    var urlString: String
}
