//
//  WeatherModel.swift
//  Weather+
//
//  Created by Александр Малахов on 08.04.2026.
//

import Foundation


struct Search: Codable, Hashable, Identifiable {
   
    let id:Int
    let name: String
    let latitude, longitude, elevation: Float
    let timezone, country: String
    let admin1, admin2, admin3, admin4 : String? 
    
}

struct GeoResults: Decodable {
    let results: [Search]
}

