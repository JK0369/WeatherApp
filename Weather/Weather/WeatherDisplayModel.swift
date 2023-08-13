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

// TODO: 장황한 코드 - 나름 프로토콜 지향으로 모델을 설계했지만 코드의 길이가 길어서 장확해보이는 코드

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
    // TODO: 중복 코드
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
