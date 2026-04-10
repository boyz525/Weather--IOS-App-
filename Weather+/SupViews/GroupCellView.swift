//
//  GroupCellView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

struct GroupCellView: View {
    let cities: [Search]
    @State private var selectedCity: Search? = nil

    var body: some View {
        GlassEffectContainer{
            VStack {
                ForEach(cities) { city in
                    CityCellView(city: city)
                        .padding(5)
                        .onTapGesture {
                            selectedCity = city
                        }
                }
            }
        }
        .sheet(item: $selectedCity) { city in
            CityDetailedViewSheet(city: city)
        }
    }
}


#Preview {
    let cities: [Search] = [
        Search(id: 1,  name: "Москва",          latitude: 55.75,  longitude: 37.61,   elevation: 144,  timezone: "Europe/Moscow",       country: "Россия",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 2,  name: "Санкт-Петербург", latitude: 59.93,  longitude: 30.31,   elevation: 5,    timezone: "Europe/Moscow",       country: "Россия",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 3,  name: "Лондон",          latitude: 51.50,  longitude: -0.12,   elevation: 11,   timezone: "Europe/London",       country: "Великобритания", admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 4,  name: "Париж",           latitude: 48.85,  longitude: 2.35,    elevation: 35,   timezone: "Europe/Paris",        country: "Франция",        admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 5,  name: "Берлин",          latitude: 52.52,  longitude: 13.40,   elevation: 34,   timezone: "Europe/Berlin",       country: "Германия",       admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 6,  name: "Токио",           latitude: 35.68,  longitude: 139.69,  elevation: 40,   timezone: "Asia/Tokyo",          country: "Япония",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 7,  name: "Нью-Йорк",        latitude: 40.71,  longitude: -74.00,  elevation: 10,   timezone: "America/New_York",    country: "США",            admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 8,  name: "Дубай",           latitude: 25.20,  longitude: 55.27,   elevation: 5,    timezone: "Asia/Dubai",          country: "ОАЭ",            admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 9,  name: "Сидней",          latitude: -33.86, longitude: 151.20,  elevation: 25,   timezone: "Australia/Sydney",    country: "Австралия",      admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 10, name: "Пекин",           latitude: 39.90,  longitude: 116.40,  elevation: 43,   timezone: "Asia/Shanghai",       country: "Китай",          admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 11, name: "Рим",             latitude: 41.89,  longitude: 12.48,   elevation: 20,   timezone: "Europe/Rome",         country: "Италия",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 12, name: "Мадрид",          latitude: 40.41,  longitude: -3.70,   elevation: 667,  timezone: "Europe/Madrid",       country: "Испания",        admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 13, name: "Амстердам",       latitude: 52.37,  longitude: 4.89,    elevation: 2,    timezone: "Europe/Amsterdam",    country: "Нидерланды",     admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 14, name: "Стокгольм",       latitude: 59.33,  longitude: 18.06,   elevation: 15,   timezone: "Europe/Stockholm",    country: "Швеция",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 15, name: "Сеул",            latitude: 37.56,  longitude: 126.97,  elevation: 38,   timezone: "Asia/Seoul",          country: "Ю. Корея",       admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 16, name: "Торонто",         latitude: 43.70,  longitude: -79.42,  elevation: 76,   timezone: "America/Toronto",     country: "Канада",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 17, name: "Каир",            latitude: 30.06,  longitude: 31.24,   elevation: 23,   timezone: "Africa/Cairo",        country: "Египет",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 18, name: "Мехико",          latitude: 19.43,  longitude: -99.13,  elevation: 2240, timezone: "America/Mexico_City", country: "Мексика",        admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 19, name: "Бангкок",         latitude: 13.75,  longitude: 100.51,  elevation: 2,    timezone: "Asia/Bangkok",        country: "Таиланд",        admin1: nil, admin2: nil, admin3: nil, admin4: nil),
        Search(id: 20, name: "Новосибирск",     latitude: 54.99,  longitude: 82.89,   elevation: 162,  timezone: "Asia/Novosibirsk",    country: "Россия",         admin1: nil, admin2: nil, admin3: nil, admin4: nil),
    ]
        GroupCellView(cities: cities)
}
