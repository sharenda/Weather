//
//  HomeView.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @StateObject private var viewModel: HomeViewModel
    
    // MARK: - Layout Constants
    enum Layout {
        enum Search {
            static let fontSize: CGFloat = 15
            static let fieldHeight: CGFloat = 46
            static let cornerRadius: CGFloat = 16
            static let horizontalPadding: CGFloat = 24
            static let iconSize: CGFloat = 17.5
            static let textFieldLeadingPadding: CGFloat = 20
            static let iconTrailingPadding: CGFloat = 14.5
        }
        
        enum Spacing {
            static let resultVertical: CGFloat = 32
            static let resultHorizontal: CGFloat = 20
            static let noCitySelectedTop: CGFloat = 240
            static let savedCityTop: CGFloat = 74
            static let searchResultsTop: CGFloat = 32
        }
        
        enum Font {
            static let noCityTitle = "Poppins-SemiBold"
            static let searchField = "Poppins-Regular"
            static let noCityTitleSize: CGFloat = 30
            static let noCitySubtitleSize: CGFloat = 15
        }
        
        static let backgroundColor = Color(red: 242/255, green: 242/255, blue: 242/255)
    }
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        Logger.info("Initializing HomeView")
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(
                query: $viewModel.searchQuery,
                onClear: viewModel.clearSearch
            )
            
            mainContent
            
            Spacer()
        }
        .task {
            await viewModel.onAppear()
        }
    }
    
    // MARK: - View Components
    @ViewBuilder
    private var mainContent: some View {
        if let searchResults = viewModel.searchResults, !searchResults.isEmpty {
            SearchResultsListView(
                results: searchResults,
                getCityWeatherUseCase: viewModel.getCityWeatherUseCase,
                onCitySelected: viewModel.saveCity
            )
        } else if let savedCity = viewModel.savedCity {
            SavedCityView(
                city: savedCity,
                getCityWeatherUseCase: viewModel.getCityWeatherUseCase
            )
        } else {
            NoCitySelectedView()
        }
    }
}

// MARK: - Subviews
private struct SearchBarView: View {
    @Binding var query: String
    let onClear: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            TextField("Search Location", text: $query)
                .font(.custom(HomeView.Layout.Font.searchField,
                              size: HomeView.Layout.Search.fontSize))
                .padding(.leading, HomeView.Layout.Search.textFieldLeadingPadding)
            
            SearchBarIcon(query: query, onClear: onClear)
                .padding(.trailing, HomeView.Layout.Search.iconTrailingPadding)
        }
        .frame(height: HomeView.Layout.Search.fieldHeight)
        .background(
            RoundedRectangle(cornerRadius: HomeView.Layout.Search.cornerRadius)
                .fill(HomeView.Layout.backgroundColor)
        )
        .padding(.horizontal, HomeView.Layout.Search.horizontalPadding)
        .padding(.top)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search location")
    }
}

private struct SearchBarIcon: View {
    let query: String
    let onClear: () -> Void
    
    var body: some View {
        Group {
            if query.isEmpty {
                Image(systemName: "magnifyingglass")
                    .searchBarIconStyle()
            } else {
                Image(systemName: "xmark")
                    .searchBarIconStyle()
                    .onTapGesture(perform: onClear)
            }
        }
    }
}

private struct SearchResultsListView: View {
    let results: [City]
    let getCityWeatherUseCase: GetCityWeatherUseCase
    let onCitySelected: (City) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: HomeView.Layout.Spacing.resultVertical) {
                ForEach(results, id: \.self) { city in
                    SearchResultCardView(
                        viewModel: SearchResultCardViewModel(
                            city: city,
                            getCityWeatherUseCase: getCityWeatherUseCase
                        )
                    )
                    .onTapGesture {
                        onCitySelected(city)
                    }
                }
            }
            .padding(.horizontal, HomeView.Layout.Spacing.resultHorizontal)
        }
        .padding(.top, HomeView.Layout.Spacing.searchResultsTop)
    }
}

private struct SavedCityView: View {
    let city: City
    let getCityWeatherUseCase: GetCityWeatherUseCase
    
    var body: some View {
        WeatherInfoView(
            viewModel: WeatherInfoViewModel(
                city: city,
                getCityWeatherUseCase: getCityWeatherUseCase
            )
        )
        .padding(.top, HomeView.Layout.Spacing.savedCityTop)
    }
}

private struct NoCitySelectedView: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("No City Selected")
                .font(.custom(HomeView.Layout.Font.noCityTitle,
                              size: HomeView.Layout.Font.noCityTitleSize))
            Text("Please Search For A City")
                .font(.custom(HomeView.Layout.Font.noCityTitle,
                              size: HomeView.Layout.Font.noCitySubtitleSize))
        }
        .padding(.top, HomeView.Layout.Spacing.noCitySelectedTop)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - ViewModifiers
private extension Image {
    func searchBarIconStyle() -> some View {
        self
            .resizable()
            .foregroundColor(.gray)
            .frame(width: HomeView.Layout.Search.iconSize,
                   height: HomeView.Layout.Search.iconSize)
    }
}

// MARK: - Preview Provider
#Preview {
    HomeView(
        viewModel: HomeViewModel(
            searchCityUseCase: SearchCityUseCaseMock(),
            saveCityUseCase: SaveCityUseCaseMock(),
            getCityWeatherUseCase: GetCityWeatherUseCaseMock(),
            getSavedCityUseCase: GetSavedCityUseCaseMock()
        )
    )
}
