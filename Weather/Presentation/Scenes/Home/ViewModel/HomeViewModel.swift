//
//  HomeViewModel.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var searchResults: [City]?
    @Published private(set) var savedCity: City?
    @Published var searchQuery: String = ""
    
    let getCityWeatherUseCase: GetCityWeatherUseCase
    
    private let getSavedCityUseCase: GetSavedCityUseCase
    private let searchCityUseCase: SearchCityUseCase
    private let saveCityUseCase: SaveCityUseCase
    
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    private enum SearchConfig {
        static let debounceInterval: TimeInterval = 0.3
    }
    
    init(
        searchCityUseCase: SearchCityUseCase,
        saveCityUseCase: SaveCityUseCase,
        getCityWeatherUseCase: GetCityWeatherUseCase,
        getSavedCityUseCase: GetSavedCityUseCase
    ) {
        Logger.info("Initializing HomeViewModel")
        self.searchCityUseCase = searchCityUseCase
        self.saveCityUseCase = saveCityUseCase
        self.getCityWeatherUseCase = getCityWeatherUseCase
        self.getSavedCityUseCase = getSavedCityUseCase
        setupSearchBinding()
    }
    
    func onAppear() async {
        Logger.info("HomeViewModel - Loading saved city")
        do {
            savedCity = try getSavedCityUseCase.execute()
            if let city = savedCity {
                Logger.info("Successfully loaded saved city: \(city.name)")
            } else {
                Logger.info("No saved city found")
            }
        } catch {
            Logger.error("Failed to load saved city", error: error)
        }
    }
    
    func saveCity(_ city: City) {
        do {
            Logger.info("Attempting to save city: \(city.name)")
            try saveCityUseCase.execute(city: city)
            savedCity = city
            clearSearch()
            Logger.info("Successfully saved city: \(city.name)")
        } catch {
            Logger.error("Failed to save city: \(city.name)", error: error)
        }
    }
    
    func clearSearch() {
        Logger.debug("Clearing search query and results")
        searchQuery = ""
        searchResults = nil
    }
    
    // MARK: - Private Methods
    private func setupSearchBinding() {
        Logger.info("Setting up search bindings")
        
        let searchPublisher = $searchQuery
            .debounce(for: .seconds(SearchConfig.debounceInterval), scheduler: DispatchQueue.main)
            .removeDuplicates()
        
        // Handle non-empty search queries
        searchPublisher
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(for: query)
            }
            .store(in: &cancellables)
        
        // Handle empty search queries
        searchPublisher
            .filter { $0.isEmpty }
            .sink { [weak self] _ in
                self?.clearSearch()
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(for query: String) {
        Logger.debug("Starting search for query: \(query)")
        searchTask?.cancel()
        
        searchTask = Task { [weak self] in
            guard let self = self else {
                Logger.error("Self is nil during search execution")
                return
            }
            
            do {
                let cities = try await searchCityUseCase.execute(query: query)
                
                if !Task.isCancelled {
                    self.searchResults = cities
                    Logger.info("Search completed with \(cities.count) results")
                }
            } catch {
                if !Task.isCancelled {
                    Logger.error("Search failed for query: \(query)", error: error)
                    self.searchResults = []
                }
            }
        }
    }
}
