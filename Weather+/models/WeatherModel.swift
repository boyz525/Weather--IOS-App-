//
//  WeatherModel.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

// MARK: - Geocoding

struct Search: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let latitude, longitude, elevation: Float
    let timezone, country: String
    let admin1, admin2, admin3, admin4: String?
}

struct GeoResults: Decodable {
    let results: [Search]?
}


struct WeatherResponse: Codable {
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyWeather
}

struct CurrentWeather: Codable {
    let time: String
    let temperature2m: Double
    let apparentTemperature: Double
    let weatherCode: Int
    let windSpeed10m: Double
    let relativeHumidity2m: Int
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m      = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode        = "weather_code"
        case windSpeed10m       = "wind_speed_10m"
        case relativeHumidity2m = "relative_humidity_2m"
        case isDay              = "is_day"
    }
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weatherCode: [Int]
    let isDay: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weatherCode   = "weather_code"
        case isDay         = "is_day"
    }
}


struct HourPoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let temperature: Double
    let weatherCode: Int
    let isDay: Bool
}

extension WeatherResponse {
   
    private var df: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm"
        f.timeZone = TimeZone(identifier: timezone) ?? .current
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }

    var hourlyPoints: [HourPoint] {
        let fmt = df
        return zip(hourly.time.indices, hourly.time).compactMap { i, s in
            guard let date = fmt.date(from: s),
                  hourly.temperature2m.indices.contains(i),
                  hourly.weatherCode.indices.contains(i),
                  hourly.isDay.indices.contains(i)
            else { return nil }
            return HourPoint(
                date: date,
                temperature: hourly.temperature2m[i],
                weatherCode: hourly.weatherCode[i],
                isDay: hourly.isDay[i] == 1
            )
        }
    }

    var upcomingPoints: [HourPoint] {
        let now = Date()
        return hourlyPoints.filter { $0.date >= now.addingTimeInterval(-1800) }
            .prefix(24)
            .map { $0 }
    }

    var upcomingEvery2h: [HourPoint] {
        Array(upcomingPoints.enumerated().compactMap { $0.offset.isMultiple(of: 2) ? $0.element : nil }.prefix(12))
    }
}

func weatherSymbol(code: Int?, isDay: Bool = true) -> String {
    switch code {
    case 0:              return isDay ? "sun.max.fill"      : "moon.stars.fill"
    case 1:              return isDay ? "sun.min.fill"      : "moon.fill"
    case 2:              return isDay ? "cloud.sun.fill"    : "cloud.moon.fill"
    case 3:              return "cloud.fill"
    case 45, 48:         return "cloud.fog.fill"
    case 51, 53, 55:     return "cloud.drizzle.fill"
    case 56, 57:         return "cloud.sleet.fill"
    case 61, 63, 65:     return "cloud.rain.fill"
    case 66, 67:         return "cloud.hail.fill"
    case 71, 73, 75, 77: return "cloud.snow.fill"
    case 80, 81, 82:     return "cloud.heavyrain.fill"
    case 85, 86:         return "snowflake"
    case 95:             return "cloud.bolt.rain.fill"
    case 96, 99:         return "cloud.bolt.fill"
    default:             return "questionmark.circle"
    }
}

func weatherDescription(code: Int?) -> String {
    switch code {
    case 0:              return "Ясно"
    case 1:              return "Преимущественно ясно"
    case 2:              return "Переменная облачность"
    case 3:              return "Пасмурно"
    case 45, 48:         return "Туман"
    case 51, 53, 55:     return "Морось"
    case 56, 57:         return "Ледяная морось"
    case 61, 63, 65:     return "Дождь"
    case 66, 67:         return "Ледяной дождь"
    case 71, 73, 75:     return "Снег"
    case 77:             return "Снежная крупа"
    case 80, 81, 82:     return "Ливень"
    case 85, 86:         return "Снегопад"
    case 95:             return "Гроза"
    case 96, 99:         return "Гроза с градом"
    default:             return "—"
    }
}

func weatherGradient(code: Int?, isDay: Bool) -> [Color] {
    guard let c = code else {
        return [Color(red: 0.20, green: 0.30, blue: 0.50), Color(red: 0.50, green: 0.65, blue: 0.85)]
    }
    switch c {
    case 0, 1:
        return isDay
            ? [Color(red: 0.20, green: 0.55, blue: 0.95), Color(red: 0.95, green: 0.75, blue: 0.45)]
            : [Color(red: 0.05, green: 0.05, blue: 0.25), Color(red: 0.25, green: 0.15, blue: 0.45)]
    case 2, 3:
        return isDay
            ? [Color(red: 0.45, green: 0.55, blue: 0.70), Color(red: 0.70, green: 0.78, blue: 0.88)]
            : [Color(red: 0.12, green: 0.14, blue: 0.22), Color(red: 0.30, green: 0.34, blue: 0.45)]
    case 45, 48:
        return [Color(red: 0.55, green: 0.60, blue: 0.65), Color(red: 0.80, green: 0.82, blue: 0.85)]
    case 51...67, 80...82:
        return [Color(red: 0.18, green: 0.25, blue: 0.45), Color(red: 0.40, green: 0.55, blue: 0.75)]
    case 71...77, 85, 86:
        return [Color(red: 0.55, green: 0.65, blue: 0.80), Color(red: 0.90, green: 0.95, blue: 1.00)]
    case 95, 96, 99:
        return [Color(red: 0.10, green: 0.10, blue: 0.20), Color(red: 0.35, green: 0.25, blue: 0.55)]
    default:
        return [Color(red: 0.20, green: 0.30, blue: 0.50), Color(red: 0.50, green: 0.65, blue: 0.85)]
    }
}
