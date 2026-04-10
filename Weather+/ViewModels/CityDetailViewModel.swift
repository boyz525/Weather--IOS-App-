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
    var forecast: SearchLL? = nil
    var isLoading: Bool = false
    var errMsg: String? = nil

    private let service = APIService()

    func loadForecast(for city: Search) async {
        isLoading = true
        errMsg = nil
        defer { isLoading = false }
        do {
            let r = try await service.fetchLL(city.latitude, city.longitude)
            forecast = r.result
        } catch {
            errMsg = error.localizedDescription
        }
    }
}
