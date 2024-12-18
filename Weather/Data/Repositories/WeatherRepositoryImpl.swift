//
//  WeatherRepositoryImpl.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    private let apiService: WeatherAPIService
    private let storage: UserDefaultsStorage
    
    init(apiService: WeatherAPIService, storage: UserDefaultsStorage) {
        self.apiService = apiService
        self.storage = storage
        Logger.info("WeatherRepositoryImpl initialized")
    }
    
    func getSavedCity() throws -> City? {
        Logger.info("Retrieving saved city")
        return try storage.getSavedCity()
    }
    
    func saveCity(_ city: City) throws {
        Logger.info("Saving city: \(city.name)")
        try storage.saveCity(city)
    }
    
    func getWeather(for city: City) async throws -> Weather {
        Logger.info("Getting weather for city: \(city.name)")
        let response = try await apiService.fetchWeather(for: city)
        return try WeatherDTOMapper.mapGetWeatherResponse(response, city: city)
    }
    
    func searchCity(query: String) async throws -> [City] {
        Logger.info("Searching for cities with query: \(query)")
        let results = try await apiService.searchCity(query: query)
        return WeatherDTOMapper.mapCityResponse(results)
    }
}
