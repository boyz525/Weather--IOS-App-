//
//  FavoritesManager.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import Foundation

@Observable
@MainActor
final class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "fav_cities"
    private(set) var cities: [Search] = []

    private init() {
        load()
    }


    func contains(_ city: Search) -> Bool {
        cities.contains(where: { $0.id == city.id })
    }

    func toggle(_ city: Search) {
        if let idx = cities.firstIndex(where: { $0.id == city.id }) {
            cities.remove(at: idx)
        } else {
            cities.insert(city, at: 0)
        }
        save()
    }

    func remove(_ city: Search) {
        cities.removeAll { $0.id == city.id }
        save()
    }


    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        if let decoded = try? JSONDecoder().decode([Search].self, from: data) {
            cities = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
