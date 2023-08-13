//
//  API.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import Foundation
import RxSwift

enum API {
    static func fetchWeatherData() -> Single<WeatherResponse> {
        .create { single in
            let jsonFileName = "sample_weather_response"
            let sampleError = NSError(domain: "1", code: 1)
            guard let jsonData = loadLocalJSONFile(named: jsonFileName) else {
                single(.failure(sampleError))
                return Disposables.create()
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
                single(.success(weatherResponse))
            } catch {
                single(.failure(sampleError))
            }
            
            return Disposables.create()
        }
    }
    
    private static func loadLocalJSONFile(named fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            print("Error reading local JSON file:", error)
        }
        return nil
    }
}
