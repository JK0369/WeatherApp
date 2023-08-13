//
//  ViewController.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

enum WeatherAction {
    case viewDidLoad
}

protocol WeatherPresentable {
    var viewModel: WeatherViewModelable { get }
    var stateObservable: Observable<WeatherState> { get }
}

class WeatherViewController: UIViewController, WeatherPresentable {
    // MARK: UI
    private let todayView = WeatherView()
    private let tomorrowView = {
        let view = WeatherView()
        // TODO: 중복코드
        view.alpha = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Properties
    private var isTodayViewFull = true
    private let disposeBag = DisposeBag()
    private let stateSubject = PublishSubject<WeatherState>()
    let viewModel: WeatherViewModelable
    var stateObservable: Observable<WeatherState> {
        stateSubject
    }
    
    // MARK: Init
    init(viewModel: WeatherViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
        viewModel.input(.viewDidLoad)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(todayView)
        view.addSubview(tomorrowView)
        
        layoutFull(todayView)
        layoutBottomTrailing(tomorrowView)
    }
    
    private func layoutFull(_ view: UIView, shouldRemake: Bool = false) {
        view.alpha = 1
        view.layer.borderColor = nil
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 0
        view.clipsToBounds = true
        
        // TODO: 중복코드1
        if shouldRemake {
            view.snp.remakeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func layoutBottomTrailing(_ view: UIView, shouldRemake: Bool = false) {
        view.alpha = 0.7
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        
        // TODO: 중복코드2
        if shouldRemake {
            view.snp.remakeConstraints {
                $0.bottom.trailing.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.size.width * 0.4)
                $0.height.equalTo(UIScreen.main.bounds.size.height * 0.4)
            }
        } else {
            view.snp.makeConstraints {
                $0.bottom.trailing.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.size.width * 0.4)
                $0.height.equalTo(UIScreen.main.bounds.size.height * 0.4)
            }
        }
    }
    
    private func bind() {
        stateSubject
            .observe(on: MainScheduler.instance)
            .bind(with: self) { ss, state in
                ss.handleOutput(state)
            }
            .disposed(by: disposeBag)
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
    }
    
    // TODO: 중복코드3
    private func handleOutput(_ state: WeatherState) {
        switch state {
        case let .loadWeather(weatherDisplayModel):
            // TODO: 중복코드
            todayView.configures(model: weatherDisplayModel.todayWeather, isTomorrow: false)
            todayView.tapViewClosure = { [weak self] in
                guard let self, !isTodayViewFull else { return }
                moveWithAnimation(fromView: todayView, toView: tomorrowView) {
                    self.isTodayViewFull.toggle()
                }
            }
            
            tomorrowView.configures(model: weatherDisplayModel.tomorrowWeather, isTomorrow: true)
            tomorrowView.tapViewClosure = { [weak self] in
                guard let self, isTodayViewFull else { return }
                moveWithAnimation(fromView: tomorrowView, toView: todayView) {
                    self.isTodayViewFull.toggle()
                }
            }
        }
    }
    
    // TODO: 장황한 코드3
    private func moveWithAnimation(fromView: UIView, toView: UIView, completion: @escaping () -> ()) {
        guard let snapshotView = fromView.snapshotView(afterScreenUpdates: true) else { return }
        snapshotView.frame = fromView.frame
        
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(snapshotView)
            snapshotView.frame = toView.frame
            fromView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            snapshotView.removeFromSuperview()
            self.layoutFull(fromView, shouldRemake: true)
            self.layoutBottomTrailing(toView, shouldRemake: true)
            self.view.bringSubviewToFront(toView)
            self.view.layoutIfNeeded()
            completion()
        })
    }
}
