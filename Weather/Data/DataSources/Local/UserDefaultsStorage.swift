//
//  UserDefaultsStorage.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

final class UserDefaultsStorage {
    private let defaults: UserDefaults
    private let cityKey: String
    
    init(defaults: UserDefaults = .standard, cityKey: String) {
        self.defaults = defaults
        self.cityKey = cityKey
        Logger.info("UserDefaultsStorage initialized with cityKey: \(cityKey)")
    }
    
    func getSavedCity() throws -> City? {
        Logger.info("Attempting to retrieve saved city")
        guard let data = defaults.data(forKey: cityKey) else {
            Logger.debug("No saved city data found")
            return nil
        }
        
        do {
            let city = try JSONDecoder().decode(City.self, from: data)
            Logger.info("Successfully retrieved saved city: \(city.name)")
            return city
        } catch {
            Logger.error("Failed to decode saved city data", error: error)
            throw error
        }
    }
    
    func saveCity(_ city: City) throws {
        Logger.info("Attempting to save city: \(city.name)")
        do {
            let data = try JSONEncoder().encode(city)
            defaults.set(data, forKey: cityKey)
            Logger.info("Successfully saved city")
        } catch {
            Logger.error("Failed to encode city data", error: error)
            throw error
        }
    }
}
