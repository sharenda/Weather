//
//  SearchResultCardView.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

/// A card view that displays weather information for a searched city
struct SearchResultCardView: View {
    // MARK: - Properties
    @State private var viewModel: SearchResultCardViewModel
    
    // MARK: - Layout Constants
    enum Layout {
        enum Font {
            static let cityName = "Poppins-SemiBold"
            static let temperature = "Poppins-Medium"
            static let cityNameSize: CGFloat = 20
            static let temperatureSize: CGFloat = 60
        }
        
        enum Spacing {
            static let vertical: CGFloat = 13
            static let horizontalPadding: CGFloat = 31
        }
        
        enum Card {
            static let height: CGFloat = 117
            static let width: CGFloat = 85
            static let cornerRadius: CGFloat = 16
            static let cityNameHeight: CGFloat = 30
        }
        
        enum Icon {
            static let width: CGFloat = 83
            static let height: CGFloat = 67
        }
        
        enum Temperature {
            static let circleSize: CGFloat = 5
            static let frameHeight: CGFloat = 42
        }
        
        static let backgroundColor = Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }
    
    // MARK: - Initialization
    init(viewModel: SearchResultCardViewModel) {
        _viewModel = State(wrappedValue: viewModel)
        Logger.info("Initializing SearchResultCardView for city: \(viewModel.city.name)")
    }
    
    // MARK: - Body
    var body: some View {
        CardContainer {
            HStack(alignment: .center) {
                cityInformationView
                Spacer()
                weatherIconView
            }
        }
        .task {
            Logger.debug("Starting weather fetch for city: \(viewModel.city.name)")
            await viewModel.fetchWeather()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Weather card for \(viewModel.city.name)")
    }
    
    // MARK: - Subviews
    private var cityInformationView: some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.vertical) {
            cityNameView
            temperatureView
        }
        .frame(height: Layout.Card.width)
        .padding(.leading, Layout.Spacing.horizontalPadding)
    }
    
    private var cityNameView: some View {
        Text(viewModel.city.name)
            .font(.custom(Layout.Font.cityName, size: Layout.Font.cityNameSize))
            .frame(height: Layout.Card.cityNameHeight)
            .accessibilityAddTraits(.isHeader)
    }
    
    private var temperatureView: some View {
        HStack(alignment: .top) {
            Text(formattedTemperature)
                .font(.custom(Layout.Font.temperature, size: Layout.Font.temperatureSize))
                .fixedSize()
                .frame(height: Layout.Temperature.frameHeight)
            
            TemperatureDegreeSymbol()
        }
        .accessibilityValue("\(formattedTemperature) degrees")
    }
    
    private var weatherIconView: some View {
        AsyncImage(url: viewModel.currentWeather?.conditionIconURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "cloud")
                .resizable()
                .scaledToFill()
        }
        .frame(width: Layout.Icon.width, height: Layout.Icon.height)
        .padding(.trailing, Layout.Spacing.horizontalPadding)
        .accessibilityHidden(true)
    }
}

// MARK: - Supporting Views
private struct CardContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(height: SearchResultCardView.Layout.Card.height)
            .background(
                RoundedRectangle(cornerRadius: SearchResultCardView.Layout.Card.cornerRadius)
                    .fill(SearchResultCardView.Layout.backgroundColor)
            )
    }
}

private struct TemperatureDegreeSymbol: View {
    var body: some View {
        Ellipse()
            .stroke(Color.black, lineWidth: 2)
            .frame(
                width: SearchResultCardView.Layout.Temperature.circleSize,
                height: SearchResultCardView.Layout.Temperature.circleSize
            )
    }
}

// MARK: - Helper Methods
private extension SearchResultCardView {
    var formattedTemperature: String {
        guard let temperature = viewModel.currentWeather?.temperature else {
            Logger.debug("Temperature not available for city: \(viewModel.city.name)")
            return "--"
        }
        return "\(Int(temperature))"
    }
}

// MARK: - Preview
#Preview {
    SearchResultCardView(
        viewModel: SearchResultCardViewModel(
            city: City(
                name: "London",
                latitude: 51.5171,
                longitude: -0.1062
            ),
            getCityWeatherUseCase: GetCityWeatherUseCaseMock()
        )
    )
    .padding()
}
