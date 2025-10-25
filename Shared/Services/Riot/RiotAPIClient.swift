//
//  RiotAPIClient.swift
//  PracticalHub
//
//  Created by David Egeler on 25.10.2025.
//
import Foundation

struct SummonerDTO: Decodable {
    let id: String
    let accountId: String
    let puuid: String
    let name: String
    let summonerLevel: Int
}
enum RiotRegion: String { case euw1, eun1, na1, kr }

final class RiotAPIClient {
    static let shared = RiotAPIClient()
    private let http = HTTPClient.shared
    private let baseURL: URL = {
        // API_BASE_URL aus Info.plist (über xcconfig gesetzt)
        let s = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? "https://YOUR_BACKEND"
        return URL(string: s)!
    }()

    func fetchSummoner(byName name: String, region: RiotRegion) async throws -> SummonerDTO {
        let safe = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
        let ep = Endpoint(path: "/riot/\(region.rawValue)/summoner/by-name/\(safe)")
        return try await http.request(baseURL, ep)
    }
}

