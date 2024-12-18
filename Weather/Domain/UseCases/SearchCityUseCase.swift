//
//  SearchCityUseCase.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

protocol SearchCityUseCase {
    func execute(query: String) async throws -> [City]
}

final class SearchCityUseCaseImpl: SearchCityUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [City] {
        Logger.info("Searching cities with query: \(query)")
        do {
            let cities = try await repository.searchCity(query: query)
            Logger.debug("Found \(cities.count) cities matching query: \(query)")
            return cities
        } catch {
            Logger.error("Failed to search cities", error: error)
            throw error
        }
    }
}

final class SearchCityUseCaseMock: SearchCityUseCase {
    func execute(query: String) async throws -> [City] {
        Logger.debug("Using mock city search results for query: \(query)")
        return [
            City(name: "London", latitude: 51.52, longitude: -0),
            City(name: "London", latitude: 42.98, longitude: -81.25),
            City(name: "Londonderry", latitude: 42.87, longitude: -71.37)
        ]
    }
}
