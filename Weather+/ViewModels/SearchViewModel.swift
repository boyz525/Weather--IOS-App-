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
    var searchName: String = ""
    var isLoading: Bool = false
    var errMsg: String? = nil

    private let service = APIService()

    func load() async {
        let query = searchName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchGeoRes = []
            return
        }
        isLoading = true
        errMsg = nil
        defer { isLoading = false }

        do {
            let r = try await service.fetchSearchGeo(query)
            searchGeoRes = r.results ?? []
        } catch {
            errMsg = error.localizedDescription
        }
    }
}
