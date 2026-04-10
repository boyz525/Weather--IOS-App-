//
//  CityDetailedViewSheet.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import Foundation
import SwiftUI

struct CityDetailedViewSheet: View {
    let city: Search
    @State private var vm = CityDetailViewModel()

    var body: some View {
        // верстай здесь, данные доступны через:
        // vm.forecast   — SearchLL? (temp, weatherCode, visibility, time)
        // vm.isLoading  — Bool
        // vm.errMsg     — String?
        // city          — Search (name, country, latitude, longitude, ...)
        Text(city.name)
            .task {
                await vm.loadForecast(for: city)
            }
    }
}

#Preview {
    let True: Bool = true
    let city = Search(id: 1, name: "Москва", latitude: 55.75, longitude: 37.61, elevation: 144, timezone: "Europe/Moscow", country: "Россия", admin1: nil, admin2: nil, admin3: nil, admin4: nil)
    VStack{
        Text("")
    }
    .sheet(isPresented:.constant(true)){
        CityDetailedViewSheet(city: city)
    } 
}
