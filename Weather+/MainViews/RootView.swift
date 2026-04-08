//
//  RootView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import SwiftUI

struct RootView: View {
    @State var vm = SearchViewModel()
    var body: some View {
        GlassEffectContainer{
            ZStack{
                TabView{
                    Tab(role: .search){
                        SearchView()
                    }
                    Tab{
                        
                    }
                }
            }
        }
    }
        
}

#Preview {
    RootView()
}
