//
//  WeatherView.swift
//  Weather
//
//  Created by 김종권 on 2023/08/13.
//

import UIKit
import SnapKit

final class WeatherView: UIView {
    // MARK: UI
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let temperatureLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let weatherDescriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    // MARK: Properties
    var tapViewClosure: (() -> ())?
    
    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        setupGesture()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    private func setupGesture() {
        // TODO: 수정은 이미 했지만 기록 - handleTapGesture라는 메소드 이름보단 callTapViewClosure가 좋음
        // callTapViewClosure은 이 메소드를 호출하는 쪽에서 메소드 안을 보지 않아도 예측할 수 있음
        // handleTapGesture은 이 메소드를 호출하는 쪽에서 메소드 내부를 예측할 수 없음 ('어떻게'의 의미만 있는 메소드명 지양할것)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(callTapViewClosure))
        addGestureRecognizer(gesture)
    }
    
    @objc
    private func callTapViewClosure() {
        tapViewClosure?()
    }
    
    // MARK: Layout
    func setupLayout() {
        backgroundColor = .white
        
        // TODO: 이미 수정했지만 addSubview하고난 후 layout을 정해주는게 직관적임
        // addSubview부분과 layout부분이 따로 있으면 위에 읽었다가, 아래 읽었다가
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height * 0.1)
        }
        
        addSubview(weatherDescriptionLabel)
        weatherDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
        }
    }
    
    // TODO: 장황한 코드1
    func configures(model: WeatherDisplayElementable, isTomorrow: Bool) {
        imageView.image = model.weather.image
        temperatureLabel.text = "\(model.temperature)°C"
        weatherDescriptionLabel.text = model.descriptionOfTemperature
        
        let titleLabel = {
            let label = UILabel()
            label.text = isTomorrow ? "(Tomorrow)" : "(today)"
            label.font = .systemFont(ofSize: 20)
            label.textColor = .white.withAlphaComponent(0.7)
            return label
        }()
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIScreen.main.bounds.height * 0.06)
            $0.centerX.equalToSuperview()
        }
    }
}
