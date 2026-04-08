//
//  APIService.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation

struct APIService {
    let geoCodeURL = "https://geocoding-api.open-meteo.com/v1/search?"
    let baseURL = "https://api.open-meteo.com/v1/forecast?"
    let lang: String = "language=ru&format=json"
    
    func fetchSearch(_ name: String) async throws -> GeoResults {
            try await get("\(geoCodeURL)name=\(name)&count=20&\(lang)")
    }
    

    
    private func get<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: path) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
