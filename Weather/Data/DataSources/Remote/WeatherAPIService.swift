//
//  WeatherAPIService.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

final class WeatherAPIService {
    private let httpClient: HTTPClient
    private let baseURL: String
    private let fetchWeatherEndpoint: String
    private let searchCityEndpoint: String
    private let apiKey: String
    
    init(
        httpClient: HTTPClient,
        baseURL: String,
        fetchWeatherEndpoint: String,
        searchCityEndpoint: String,
        apiKey: String
    ) {
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.fetchWeatherEndpoint = fetchWeatherEndpoint
        self.searchCityEndpoint = searchCityEndpoint
        self.apiKey = apiKey
        Logger.info("WeatherAPIService initialized with baseURL: \(baseURL)")
    }
    
    func fetchWeather(for city: City) async throws -> GetWeatherAPIResponse {
        Logger.info("Fetching weather for city: \(city.name)")
        let coordinates = "\(city.latitude),\(city.longitude)"
        let url = try makeURL(endpoint: fetchWeatherEndpoint, query: coordinates)
        return try await httpClient.request(url)
    }
    
    func searchCity(query: String) async throws -> SearchCityAPIResponse {
        Logger.info("Searching for city with query: \(query)")
        let url = try makeURL(endpoint: searchCityEndpoint, query: query)
        return try await httpClient.request(url)
    }
    
    private func makeURL(endpoint: String, query: String) throws -> URL {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? endpoint
        let urlString = "\(baseURL)\(encodedEndpoint)?q=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            Logger.error("Failed to create URL from string: \(urlString)")
            throw NetworkError.badURL
        }
        return url
    }
}
