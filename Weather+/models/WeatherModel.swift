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

struct SearchLL: Codable{
    let temp:[Float]
    let weatherCode, visibility: [Int]
    let time: [String]
    
    enum CodingKeys:String, CodingKey {
        case temp = "temperature_120m"
        case weatherCode = "weather_code"
        case visibility = "visibility"
        case time = "time"
    }
    
}

struct LLResult: Codable {
    let result: SearchLL
    
    enum CodingKeys: String, CodingKey{
        case result = "hourly"
    }
}

