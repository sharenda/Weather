//
//  GetCityWeatherUseCase.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

protocol GetCityWeatherUseCase {
    func execute(city: City) async throws -> Weather
}

final class GetCityWeatherUseCaseImpl: GetCityWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(city: City) async throws -> Weather {
        Logger.info("Fetching weather for city: \(city.name)")
        do {
            let weather = try await repository.getWeather(for: city)
            Logger.debug("Successfully retrieved weather for \(city.name)")
            return weather
        } catch {
            Logger.error("Failed to fetch weather", error: error)
            throw error
        }
    }
}

final class GetCityWeatherUseCaseMock: GetCityWeatherUseCase {
    func execute(city: City) async throws -> Weather {
        Logger.debug("Using mock weather data for \(city.name)")
        return Weather(
            temperature: 10.1,
            conditionIconURL: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/116.png")!,
            humidity: 94,
            uvIndex: 0.2,
            feelsLikeTemperature: 8.3
        )
    }
}
