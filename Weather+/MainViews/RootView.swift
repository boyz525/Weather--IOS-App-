//
//  RootView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Погода", systemImage: "cloud.sun.fill") {
                HomeView()
            }

            Tab(role: .search) {
                SearchView()
            }
        }
        .tint(.white)
    }
}

#Preview {
    RootView()
}
