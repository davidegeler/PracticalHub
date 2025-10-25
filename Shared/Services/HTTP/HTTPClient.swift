//
//  HTTPClient.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//
import Foundation

enum HTTPError: Error { case badStatus(Int), invalidURL, decoding }

final class HTTPClient {
    static let shared = HTTPClient()
    private init() {}

    func request<T: Decodable>(_ baseURL: URL, _ endpoint: Endpoint) async throws -> T {
        guard var comps = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw HTTPError.invalidURL
        }
        comps.queryItems = endpoint.query.isEmpty ? nil : endpoint.query
        guard let url = comps.url else { throw HTTPError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method
        endpoint.headers.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw HTTPError.decoding }
        guard (200..<300).contains(http.statusCode) else { throw HTTPError.badStatus(http.statusCode) }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
