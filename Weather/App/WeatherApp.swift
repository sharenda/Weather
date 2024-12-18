//
//  WeatherApp.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    let container = AppContainer.makeContainer()
    
    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(
                    searchCityUseCase: container.searchCityUseCase,
                    saveCityUseCase: container.saveCityUseCase,
                    getCityWeatherUseCase: container.getCityWeatherUseCase,
                    getSavedCityUseCase: container.getSavedCityUseCase
                )
            )
            .preferredColorScheme(.light)
        }
    }
}
