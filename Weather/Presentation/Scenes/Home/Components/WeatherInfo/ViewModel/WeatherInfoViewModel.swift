//
//  WeatherInfoViewModel.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

@MainActor
@Observable final class WeatherInfoViewModel {
    private(set) var weather: Weather?
    
    let city: City
    private let getCityWeatherUseCase: GetCityWeatherUseCase
    
    init(city: City, getCityWeatherUseCase: GetCityWeatherUseCase) {
        self.city = city
        self.getCityWeatherUseCase = getCityWeatherUseCase
        Logger.info("Initializing WeatherInfoViewModel for city: \(city.name)")
    }
    
    func fetchWeather() async {
        do {
            Logger.info("Starting weather fetch for city: \(city.name)")
            weather = try await getCityWeatherUseCase.execute(city: city)
            Logger.info("Successfully fetched weather for city: \(city.name)")
        } catch {
            Logger.error("Failed to fetch weather for city: \(city.name)", error: error)
        }
    }
}
