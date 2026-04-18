//
//  HomeView.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var favorites = FavoritesManager.shared
    @State private var vm = HomeViewModel()
    @State private var selectedCity: Search? = nil

    var body: some View {
        ZStack {
            backdrop
            content
        }
        .preferredColorScheme(.dark)
        .task(id: favorites.cities.map(\.id)) {
            await vm.loadAll(for: favorites.cities)
        }
        .sheet(item: $selectedCity) { city in
            CityDetailedViewSheet(city: city)
        }
    }

    private var backdrop: some View {
        Group {
            if let first = favorites.cities.first,
               let f = vm.forecasts[first.id] {
                WeatherBackground(code: f.current.weatherCode, isDay: f.current.isDay == 1)
            } else {
                WeatherBackground(code: nil, isDay: true)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if favorites.cities.isEmpty {
            emptyState
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerRow

                    ForEach(favorites.cities) { city in
                        Button {
                            selectedCity = city
                        } label: {
                            CityWeatherCard(
                                city: city,
                                forecast: vm.forecasts[city.id],
                                loading: vm.loading.contains(city.id),
                                onRemove: { favorites.remove(city) }
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Color.clear.frame(height: 60)
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await vm.refresh(cities: favorites.cities)
            }
        }
    }

    private var headerRow: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Погода")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text("\(favorites.cities.count) \(pluralCities(favorites.cities.count))")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "heart.slash")
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(.white.opacity(0.85))
            Text("Нет избранных городов")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            Text("Найдите город на вкладке поиска\nи добавьте его в избранное")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.75))
        }
        .padding(30)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28))
        .padding(30)
    }

    private func pluralCities(_ n: Int) -> String {
        let mod10 = n % 10, mod100 = n % 100
        if mod10 == 1 && mod100 != 11 { return "город" }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "города" }
        return "городов"
    }
}


struct CityWeatherCard: View {
    let city: Search
    let forecast: WeatherResponse?
    let loading: Bool
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(city.name)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(city.country)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                if let f = forecast {
                    Text("\(Int(f.current.temperature2m.rounded()))°")
                        .font(.system(size: 56, weight: .thin, design: .rounded))
                        .foregroundStyle(.white)
                } else if loading {
                    ProgressView().tint(.white)
                }
            }

            if let f = forecast {
                HStack(spacing: 10) {
                    Image(systemName: weatherSymbol(code: f.current.weatherCode,
                                                    isDay: f.current.isDay == 1))
                        .symbolRenderingMode(.multicolor)
                        .font(.title3)
                    Text(weatherDescription(code: f.current.weatherCode))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                    Label(String(format: "%.1f м/с", f.current.windSpeed10m),
                          systemImage: "wind")
                        .labelStyle(.titleAndIcon)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                }

                TemperatureChart(points: Array(f.upcomingPoints.prefix(24)),
                                 timezone: f.timezone)
                    .frame(height: 120)

                HourlyStrip(points: f.upcomingEvery2h, timezone: f.timezone)
                    .padding(.horizontal, -16)
            } else if loading {
                Color.clear.frame(height: 40)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: weatherGradient(code: forecast?.current.weatherCode,
                                        isDay: (forecast?.current.isDay ?? 1) == 1)
                    .map { $0.opacity(0.55) },
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 26))
        .contextMenu {
            Button(role: .destructive) {
                onRemove()
            } label: {
                Label("Удалить из избранного", systemImage: "heart.slash")
            }
        }
    }
}

#Preview {
    HomeView()
}
