//
//  WeatherService.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import Foundation
import RxSwift

protocol WeatherServicable {
    func getWeather() -> Single<WeatherDisplayModel>
}

final class WeatherService: WeatherServicable {
    func getWeather() -> Single<WeatherDisplayModel> {
        API
            .fetchWeatherData()
            .map { .init(todayWeather: $0.todayWeather, tomorrowWeather: $0.tomorrowWeather) }
    }
}
