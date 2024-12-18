//
//  AppConstants.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

enum AppConstants {
    enum WeatherAPI {
        static let baseURL = "https://api.weatherapi.com"
        
        enum Endpoints {
            static let current = "/v1/current.json"
            static let search = "/v1/search.json"
        }
        
        static func fetchAPIKey() throws -> String {
            guard let configPath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
                Logger.error("Weather API configuration file not found")
                throw ConfigurationError.missingConfigFile
            }
            
            guard let config = NSDictionary(contentsOfFile: configPath) else {
                Logger.error("Invalid weather API configuration data")
                throw ConfigurationError.invalidConfigData
            }
            
            guard let apiKey = config["WeatherAPIKey"] as? String, !apiKey.isEmpty else {
                Logger.error("Invalid or missing weather API key in configuration")
                throw ConfigurationError.invalidAPIKey
            }
            
            Logger.info("Weather API key successfully retrieved")
            return apiKey
        }
    }
    
    enum UserDefaults {
        static let cityKey = "saved_city"
    }
}
