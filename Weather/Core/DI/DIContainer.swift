//
//  DIContainer.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

final class DIContainer {
    let weatherRepository: WeatherRepository
    
    let searchCityUseCase: SearchCityUseCase
    let saveCityUseCase: SaveCityUseCase
    let getCityWeatherUseCase: GetCityWeatherUseCase
    let getSavedCityUseCase: GetSavedCityUseCase
    
    init(
        weatherRepository: WeatherRepository,
        searchCityUseCase: SearchCityUseCase,
        saveCityUseCase: SaveCityUseCase,
        getCityWeatherUseCase: GetCityWeatherUseCase,
        getSavedCityUseCase: GetSavedCityUseCase
    ) {
        self.weatherRepository = weatherRepository
        self.searchCityUseCase = searchCityUseCase
        self.saveCityUseCase = saveCityUseCase
        self.getCityWeatherUseCase = getCityWeatherUseCase
        self.getSavedCityUseCase = getSavedCityUseCase
        
        Logger.debug("DIContainer initialized successfully")
    }
}
