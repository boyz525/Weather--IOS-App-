//
//  SearchView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

struct SearchView:View {
    @State var vm = SearchViewModel()
    var body: some View {
        NavigationStack{
            AnimatedBack()
                .ignoresSafeArea()
                .padding(.bottom, -550)
            Group{
                if vm.searchName == "" {
                    EmptyQuery()
                        .padding(.bottom, 250)
                }  else if vm.isLoading == true {
                    LoadingOverlay()
                        .padding(.bottom, 250)
                } else if vm.searchGeoRes.isEmpty {
                    NotFound()
                        .padding(.bottom, 250)
                } else {
                    ResList(cities: vm.searchGeoRes)
                   
                }
                    }
            .navigationTitle("Поиск")
                }
        .padding(.top, -50)
        .ignoresSafeArea()
            .searchable(
                text: $vm.searchName,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Город, страна..."
            )
            .onChange( of: vm.searchName ) { _ , _ in
                Task{
                    await vm.load()
            }
        }
    }
}
    

struct EmptyQuery: View {
    var body: some View {
        VStack{
            Image(systemName:"magnifyingglass")
                .font(.system(size: 100))
                .padding(.bottom, 10)
            Text("Введите ваш запрос...")
                .font(.title2)
                .bold()
        }
    }
}

struct NotFound: View {
    var body: some View {
        VStack{
            Image(systemName:"wrench.and.screwdriver")
                .font(.system(size: 100))
                .padding(.bottom, 10)
            Text("Ничего не нашлось...🥲")
                .font(.title2)
                .bold()
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        VStack(alignment: .center){
            ProgressView()
                .scaleEffect(2.5)
             Text("Загрузка...")
                .padding(.top, 10)
        }
        .padding(.top, 25)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct ResList: View {
    let cities: [Search]
    
    var body: some View {
            ScrollView{
                GroupCellView(cities: cities)
                    .padding(.horizontal, 60)
        }
            .padding(.top, -350)
    }
}






#Preview {
        RootView()
}
