//
//  SearchViewModel.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation

@Observable
@MainActor
final class SearchViewModel {
            var searchGeoRes: [Search] = []
            var searchLLRes: SearchLL? = nil
            var searchName: String = ""
            var isLoading: Bool = false
    private var service = APIService()
            var errMsg:String? = nil
    
    
    func loadForecast(for city: Search) async {
        isLoading = true
        errMsg = nil
        defer {isLoading = false}

        do {
            let r = try await service.fetchLL(city.latitude, city.longitude)
            searchLLRes = r.result
        } catch {
            errMsg = error.localizedDescription
        }
    }
    
    func load() async {
        isLoading = true
        errMsg = nil
        defer { isLoading = false }
        
        do {
            let r = try await service.fetchSearchGeo(searchName)
            searchGeoRes = r.results
        } catch {
            errMsg = error.localizedDescription
        }
    }
}
