//
//  HomeViewModel.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    var forecasts: [Int: WeatherResponse] = [:]
    var loading: Set<Int> = []
    var errors: [Int: String] = [:]

    private let service = APIService()

    func loadAll(for cities: [Search]) async {
        await withTaskGroup(of: Void.self) { group in
            for city in cities {
                group.addTask { [weak self] in
                    await self?.load(for: city)
                }
            }
        }
    }

    func load(for city: Search) async {
        loading.insert(city.id)
        errors[city.id] = nil
        defer { loading.remove(city.id) }
        do {
            forecasts[city.id] = try await service.fetchWeather(city.latitude, city.longitude)
        } catch {
            errors[city.id] = error.localizedDescription
        }
    }

    func refresh(cities: [Search]) async {
        forecasts.removeAll()
        await loadAll(for: cities)
    }
}
