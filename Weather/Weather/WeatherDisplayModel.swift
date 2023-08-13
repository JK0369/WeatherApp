//
//  WeatherDisplayModel.swift
//  Weather
//
//  Created by 김종권 on 2023/08/13.
//

import Foundation
import UIKit

enum Weather: String, Codable {
    case clouds
    case sunny
    case unknown
    
    var image: UIImage? {
        switch self {
        case .clouds:
            return UIImage(named: "cloud")
        case .sunny, .unknown:
            return UIImage(named: "sunny")
        }
    }
}


// MARK: - WeatherDisplayElementable

protocol WeatherDisplayElementable {
    var weather: Weather { get }
    var temperature: Double { get }
    var descriptionOfTemperature: String { get }
}

struct WeatherDisplayElement: WeatherDisplayElementable {
    let weather: Weather
    let temperature: Double
    let descriptionOfTemperature: String
}


// MARK: - WeatherDisplayModel

protocol WeatherDisplable {
    var todayWeather: WeatherDisplayElementable { get }
    var tomorrowWeather: WeatherDisplayElementable { get }
}

struct WeatherDisplayModel: WeatherDisplable {
    let todayWeather: WeatherDisplayElementable
    let tomorrowWeather: WeatherDisplayElementable
}


// MARK: - WeatherResponse + WeatherDisplable

extension WeatherResponse: WeatherDisplable {
    var todayWeather: WeatherDisplayElementable {
        WeatherDisplayElement(
            weather: Weather(rawValue: today.weather.main) ?? .unknown,
            temperature: Double(today.temp),
            descriptionOfTemperature: today.weather.description
        )
    }
    var tomorrowWeather: WeatherDisplayElementable {
        WeatherDisplayElement(
            weather: Weather(rawValue: tomorrow.weather.main) ?? .unknown,
            temperature: Double(tomorrow.temp),
            descriptionOfTemperature: tomorrow.weather.description
        )
    }
}
