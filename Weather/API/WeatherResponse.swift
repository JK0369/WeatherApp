//
//  WhatherResponse.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import Foundation

struct WeatherResponse: Codable {
    struct Day: Codable {
        struct Weather: Codable {
            let id: Int
            let main, description: String
        }
        
        let dt, temp: Int
        let weather: Weather
    }
    
    let today, tomorrow: Day
}
