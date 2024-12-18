//
//  GetSavedCityUseCase.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation

protocol GetSavedCityUseCase {
    func execute() throws -> City?
}

final class GetSavedCityUseCaseImpl: GetSavedCityUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute() throws -> City? {
        Logger.info("Retrieving saved city")
        do {
            let city = try repository.getSavedCity()
            Logger.debug("Successfully retrieved saved city: \(String(describing: city?.name))")
            return city
        } catch {
            Logger.error("Failed to retrieve saved city", error: error)
            throw error
        }
    }
}

final class GetSavedCityUseCaseMock: GetSavedCityUseCase {
    func execute() throws -> City? {
        Logger.debug("Using mock saved city: returning nil")
        return nil
    }
}
