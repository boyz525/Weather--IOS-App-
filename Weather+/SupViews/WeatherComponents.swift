//
//  WeatherComponents.swift
//  Weather+
//
//  Created by Александр Малахов on 10.04.2026.
//

import SwiftUI
import Charts


struct WeatherBackground: View {
    let code: Int?
    let isDay: Bool
    @State private var animate = false

    var body: some View {
        let palette = weatherGradient(code: code, isDay: isDay)
        ZStack {
            LinearGradient(colors: palette, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(palette.first?.opacity(0.55) ?? .blue.opacity(0.5))
                .frame(width: 360)
                .blur(radius: 80)
                .offset(x: animate ? 140 : -140, y: animate ? -180 : -260)

            Circle()
                .fill(palette.last?.opacity(0.55) ?? .purple.opacity(0.5))
                .frame(width: 420)
                .blur(radius: 90)
                .offset(x: animate ? -120 : 120, y: animate ? 260 : 160)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animate)
        .onAppear { animate = true }
    }
}


struct HourlyPill: View {
    let point: HourPoint
    let timezone: String

    private var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.timeZone = TimeZone(identifier: timezone) ?? .current
        return f.string(from: point.date)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(timeString)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))

            Image(systemName: weatherSymbol(code: point.weatherCode, isDay: point.isDay))
                .symbolRenderingMode(.multicolor)
                .font(.title3)
                .frame(height: 28)

            Text("\(Int(point.temperature.rounded()))°")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .frame(minWidth: 68)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
}


struct HourlyStrip: View {
    let points: [HourPoint]
    let timezone: String

    var body: some View {
        GlassEffectContainer(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(points) { p in
                        HourlyPill(point: p, timezone: timezone)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            }
        }
    }
}


struct TemperatureChart: View {
    let points: [HourPoint]
    let timezone: String

    private var minT: Double { (points.map(\.temperature).min() ?? 0) - 2 }
    private var maxT: Double { (points.map(\.temperature).max() ?? 0) + 2 }

    var body: some View {
        Chart {
            ForEach(points) { p in
                AreaMark(
                    x: .value("Время", p.date),
                    y: .value("Темп", p.temperature)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white.opacity(0.55), .white.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Время", p.date),
                    y: .value("Темп", p.temperature)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: minT...maxT)
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                AxisValueLabel(format: .dateTime.hour().locale(Locale(identifier: "ru_RU")),
                               collisionResolution: .greedy)
                    .foregroundStyle(.white.opacity(0.7))
                AxisGridLine().foregroundStyle(.white.opacity(0.15))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisValueLabel().foregroundStyle(.white.opacity(0.7))
                AxisGridLine().foregroundStyle(.white.opacity(0.15))
            }
        }
    }
}


struct InfoPill: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title.uppercased())
                    .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(.white.opacity(0.75))

            Text(value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
}
