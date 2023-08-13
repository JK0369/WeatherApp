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
            
            // TODO: 깊이가 깊은 코드1
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
        // TODO: do - catch문은 if else문이라고 생각할 것 -> return nil이 catch문 안에 있어야 더욱 읽히기 쉬움
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            print("Error reading local JSON file:", error)
        }
        return nil
    }
}
