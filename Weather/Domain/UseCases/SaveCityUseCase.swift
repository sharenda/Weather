//
//  SaveCityUseCase.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

protocol SaveCityUseCase {
    func execute(city: City) throws
}

final class SaveCityUseCaseImpl: SaveCityUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(city: City) throws {
        Logger.info("Saving city: \(city.name)")
        do {
            try repository.saveCity(city)
            Logger.debug("Successfully saved city: \(city.name)")
        } catch {
            Logger.error("Failed to save city", error: error)
            throw error
        }
    }
}

final class SaveCityUseCaseMock: SaveCityUseCase {
    func execute(city: City) throws {
        Logger.debug("Mock saving city: \(city.name)")
    }
}
