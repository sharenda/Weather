//
//  WeatherRepository.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

protocol WeatherRepository {
    func getSavedCity() throws -> City?
    func saveCity(_ city: City) throws
    func getWeather(for city: City) async throws -> Weather
    func searchCity(query: String) async throws -> [City]
}
