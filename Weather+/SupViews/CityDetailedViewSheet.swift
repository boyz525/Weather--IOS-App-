//
//  CityDetailedViewSheet.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import SwiftUI

struct CityDetailedViewSheet: View {
    let city: Search
    @State private var vm = CityDetailViewModel()
    @State private var favorites = FavoritesManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            WeatherBackground(
                code: vm.forecast?.current.weatherCode,
                isDay: (vm.forecast?.current.isDay ?? 1) == 1
            )

            if vm.isLoading && vm.forecast == nil {
                LoadingOverlay()
            } else if let forecast = vm.forecast {
                DetailContent(city: city, forecast: forecast, favorites: favorites)
            } else if let err = vm.errMsg {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                    Text(err)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(.white)
                .padding(24)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
                .padding(32)
            }
        }
        .preferredColorScheme(.dark)
        .task { await vm.loadForecast(for: city) }
    }
}


private struct DetailContent: View {
    let city: Search
    let forecast: WeatherResponse
    let favorites: FavoritesManager

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                hero
                statsGrid
                hourlyBlock
                chartBlock
                Color.clear.frame(height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
    }


    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text(city.country)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
            }
            Spacer()
            FavoriteButton(city: city, favorites: favorites)
        }
    }


    private var hero: some View {
        let c = forecast.current
        return VStack(spacing: 6) {
            Image(systemName: weatherSymbol(code: c.weatherCode, isDay: c.isDay == 1))
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 96))
                .shadow(color: .black.opacity(0.25), radius: 14, y: 6)
                .padding(.bottom, 4)

            Text("\(Int(c.temperature2m.rounded()))°")
                .font(.system(size: 110, weight: .thin, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)

            Text(weatherDescription(code: c.weatherCode))
                .font(.title3.weight(.medium))
                .foregroundStyle(.white)

            Text("Ощущается как \(Int(c.apparentTemperature.rounded()))°")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.top, 8)
    }


    private var statsGrid: some View {
        let c = forecast.current
        return GlassEffectContainer(spacing: 12) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                InfoPill(icon: "wind", title: "Ветер",
                         value: String(format: "%.1f м/с", c.windSpeed10m))
                InfoPill(icon: "humidity.fill", title: "Влажность",
                         value: "\(c.relativeHumidity2m)%")
                InfoPill(icon: "thermometer.medium", title: "Ощущается",
                         value: "\(Int(c.apparentTemperature.rounded()))°")
                InfoPill(icon: c.isDay == 1 ? "sun.max.fill" : "moon.fill",
                         title: c.isDay == 1 ? "День" : "Ночь",
                         value: timeString(from: c.time))
            }
        }
    }

    private func timeString(from iso: String) -> String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm"
        parser.timeZone = TimeZone(identifier: forecast.timezone) ?? .current
        guard let date = parser.date(from: iso) else { return iso }
        let out = DateFormatter()
        out.dateFormat = "HH:mm"
        out.timeZone = TimeZone(identifier: forecast.timezone) ?? .current
        return out.string(from: date)
    }


    private var hourlyBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "clock.fill", title: "На ближайшие часы")
            HourlyStrip(points: forecast.upcomingEvery2h, timezone: forecast.timezone)
        }
    }


    private var chartBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(icon: "chart.line.uptrend.xyaxis", title: "Температура на 24 часа")
            TemperatureChart(points: Array(forecast.upcomingPoints.prefix(24)),
                             timezone: forecast.timezone)
                .frame(height: 180)
                .padding(16)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
        }
    }
}


struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .tracking(0.5)
        }
        .foregroundStyle(.white.opacity(0.8))
        .padding(.leading, 4)
    }
}


struct FavoriteButton: View {
    let city: Search
    let favorites: FavoritesManager

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                favorites.toggle(city)
            }
        } label: {
            Image(systemName: favorites.contains(city) ? "heart.fill" : "heart")
                .font(.title2.weight(.semibold))
                .foregroundStyle(favorites.contains(city) ? .pink : .white)
                .frame(width: 44, height: 44)
        }
        .glassEffect(.clear.interactive(), in: Circle())
    }
}

#Preview {
    let city = Search(
        id: 1, name: "Москва", latitude: 55.75, longitude: 37.61,
        elevation: 144, timezone: "Europe/Moscow", country: "Россия",
        admin1: nil, admin2: nil, admin3: nil, admin4: nil
    )
    return Color.black
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            CityDetailedViewSheet(city: city)
        }
}
