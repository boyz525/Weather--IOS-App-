//
//  CityDetailViewModel.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import Foundation

@Observable
@MainActor
final class CityDetailViewModel {
    var forecast: WeatherResponse? = nil
    var isLoading: Bool = false
    var errMsg: String? = nil

    private let service = APIService()

    func loadForecast(for city: Search) async {
        isLoading = true
        errMsg = nil
        defer { isLoading = false }
        do {
            forecast = try await service.fetchWeather(city.latitude, city.longitude)
        } catch {
            errMsg = error.localizedDescription
        }
    }
}
