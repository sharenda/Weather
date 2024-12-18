//
//  WeatherDTOMapper.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

enum WeatherDTOMapper {
    static func mapGetWeatherResponse(_ response: GetWeatherAPIResponse, city: City) throws -> Weather {
        Logger.info("Mapping weather response for city: \(city.name)")
        
        let details = response.current
        guard let iconURL = URL(string: "https:\(details.condition.icon)") else {
            Logger.error("Failed to create icon URL from path: \(details.condition.icon)")
            throw NetworkError.invalidIconURL
        }
        
        let weather = Weather(
            temperature: details.tempC,
            conditionIconURL: iconURL,
            humidity: details.humidity,
            uvIndex: details.uv,
            feelsLikeTemperature: details.feelslikeC
        )
        
        Logger.debug("Successfully mapped weather data: temp: \(weather.temperature)°C, humidity: \(weather.humidity)%")
        return weather
    }
    
    static func mapCityResponse(_ response: SearchCityAPIResponse) -> [City] {
        Logger.info("Mapping city search response with \(response.count) results")
        
        let cities = response.map { dto in
            City(name: dto.name, latitude: dto.lat, longitude: dto.lon)
        }
        
        Logger.debug("Mapped \(cities.count) cities")
        return cities
    }
}
