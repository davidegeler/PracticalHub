//
//  Endpoint.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//


import Foundation

struct Endpoint {
    var path: String
    var query: [URLQueryItem] = []
    var method: String = "GET"
    var headers: [String:String] = [:]
}
