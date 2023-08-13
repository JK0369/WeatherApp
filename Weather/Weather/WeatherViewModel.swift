//
//  WeatherViewModel.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import RxSwift
import RxCocoa

enum WeatherState {
    case loadWeather(WeatherDisplayModel)
}

protocol WeatherViewModelable {
    var output: Observable<WeatherState> { get }
    
    func input(_ action: WeatherAction)
}

final class WeatherViewModel: WeatherViewModelable {
    struct Dependency {
        let service: WeatherServicable
    }
    
    private let dependency: Dependency
    private let disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: Output
    var output: Observable<WeatherState> {
        outputSubject
    }
    private var outputSubject = PublishSubject<WeatherState>()
    
    // MARK: Input
    func input(_ action: WeatherAction) {
        switch action {
            // TODO: 장황한 코드2
        case .viewDidLoad:
            dependency
                .service
                .getWeather()
                .subscribe(onSuccess: { [weak outputSubject] display in
                    outputSubject?.onNext(.loadWeather(display))
                }, onFailure: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
    }
}
