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
            var searchRes: [Search] = []
            var searchName: String = ""
            var isLoading: Bool = false
    private var service = APIService()
            var errMsg:String? = nil
    
    
    
    func load() async {
        isLoading = true
        errMsg = nil
        defer { isLoading = false }
        
        do {
            let r = try await service.fetchSearch(searchName)
            searchRes = r.results
        } catch {
            errMsg = error.localizedDescription
        }
    }
}
