//
//  SearchResultCardViewModel.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

@MainActor
@Observable final class SearchResultCardViewModel {
    private(set) var currentWeather: Weather?
    
    let city: City
    private let getCityWeatherUseCase: GetCityWeatherUseCase
    
    init(city: City, getCityWeatherUseCase: GetCityWeatherUseCase) {
        self.city = city
        self.getCityWeatherUseCase = getCityWeatherUseCase
        Logger.info("Initializing SearchResultCardViewModel for city: \(city.name)")
    }
    
    func fetchWeather() async {
        do {
            Logger.info("Starting weather fetch for search result card - city: \(city.name)")
            currentWeather = try await getCityWeatherUseCase.execute(city: city)
            Logger.info("Successfully fetched weather for search result card - city: \(city.name)")
        } catch {
            Logger.error("Failed to fetch weather for search result card - city: \(city.name)", error: error)
        }
    }
}
