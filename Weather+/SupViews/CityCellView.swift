//
//  CityCellView.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation
import SwiftUI

struct CityCellView: View {
    let city: Search

    var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                Text("\(city.name),")
                    .font(.title)
                Text(city.country)
                    .font(.title2)
                    .padding(.top, 4)
            }
            .padding(.leading, 15)
            .padding(.top, 5)
            
            Text(city.timezone)
                .padding(.leading, 15)
                
        
            HStack()  {
                Text(String(format:"%.2f, %.2f", city.latitude, city.longitude))
                Spacer()
                Text("\(String(format: "%.0f", city.elevation,)) м над морем")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal,15 )
            .padding(.top, 25)
            .padding(.bottom, 5)
        }
        .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    CityCellView(city: Search(
        id: 1,
        name: "Москва",
        latitude: 55.75,
        longitude: 37.61,
        elevation: 144,
        timezone: "Europe/Moscow",
        country: "Россия",
        admin1: nil, admin2: nil, admin3: nil, admin4: nil
    ))
    .background(.gray)
}
