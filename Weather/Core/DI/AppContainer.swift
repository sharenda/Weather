//
//  AppContainer.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

enum AppContainer {
    static func makeContainer() -> DIContainer {
        Logger.debug("Building production container")
        
        let apiKey: String
        do {
            apiKey = try AppConstants.WeatherAPI.fetchAPIKey()
        } catch {
            Logger.error("Fatal initialization error - Weather API key not available, app cannot function", error: error)
            fatalError("Weather API key is required for app functionality")
        }
        
        // Network layer
        let httpClient = HTTPClient()
        let apiService = WeatherAPIService(
            httpClient: httpClient,
            baseURL: AppConstants.WeatherAPI.baseURL,
            fetchWeatherEndpoint: AppConstants.WeatherAPI.Endpoints.current,
            searchCityEndpoint: AppConstants.WeatherAPI.Endpoints.search,
            apiKey: apiKey
        )
        
        // Storage layer
        let localStorage = UserDefaultsStorage(cityKey: AppConstants.UserDefaults.cityKey)
        
        // Repository layer
        let weatherRepository = WeatherRepositoryImpl(
            apiService: apiService,
            storage: localStorage
        )
        
        // Use cases
        let searchCityUseCase = SearchCityUseCaseImpl(repository: weatherRepository)
        let saveCityUseCase = SaveCityUseCaseImpl(repository: weatherRepository)
        let getCityWeatherUseCase = GetCityWeatherUseCaseImpl(repository: weatherRepository)
        let getSavedCityUseCase = GetSavedCityUseCaseImpl(repository: weatherRepository)
        
        Logger.debug("App container successfully created")
        return DIContainer(
            weatherRepository: weatherRepository,
            searchCityUseCase: searchCityUseCase,
            saveCityUseCase: saveCityUseCase,
            getCityWeatherUseCase: getCityWeatherUseCase,
            getSavedCityUseCase: getSavedCityUseCase
        )
    }
}
