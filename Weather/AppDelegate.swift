//
//  AppDelegate.swift
//  Weather
//
//  Created by 김종권 on 2023/08/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let dependency = WeatherViewModel.Dependency(service: WeatherService())
        let viewModel = WeatherViewModel(dependency: dependency)
        window.rootViewController = WeatherViewController(viewModel: viewModel)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

