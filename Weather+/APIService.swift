//
//  APIService.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation

struct APIService {
    let geoCodeURL = "https://geocoding-api.open-meteo.com/v1/search?"
    let baseURL    = "https://api.open-meteo.com/v1/forecast?"
    let lang       = "language=ru&format=json"

    func fetchSearchGeo(_ name: String) async throws -> GeoResults {
        let q = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        return try await get("\(geoCodeURL)name=\(q)&count=20&\(lang)")
    }

    func fetchWeather(_ latitude: Float, _ longitude: Float) async throws -> WeatherResponse {
        let current = "current=temperature_2m,apparent_temperature,weather_code,wind_speed_10m,relative_humidity_2m,is_day"
        let hourly  = "hourly=temperature_2m,weather_code,is_day"
        let extra   = "forecast_days=2&timezone=auto&wind_speed_unit=ms"
        return try await get("\(baseURL)latitude=\(latitude)&longitude=\(longitude)&\(current)&\(hourly)&\(extra)")
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
