//
//  WeatherAPIModels.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

// MARK: - SearchCityAPIResponse
typealias SearchCityAPIResponse = [CitySearchResult]

struct CitySearchResult: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}

// MARK: - GetCityWeatherAPIResponse
struct GetWeatherAPIResponse: Decodable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Decodable {
    let tempC: Double
    let condition: Condition
    let humidity: Int
    let feelslikeC: Double
    let uv: Double
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition = "condition"
        case humidity = "humidity"
        case feelslikeC = "feelslike_c"
        case uv = "uv"
    }
}

// MARK: - Condition
struct Condition: Decodable {
    let icon: String
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}
