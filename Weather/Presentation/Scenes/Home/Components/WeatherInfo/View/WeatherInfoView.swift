//
//  WeatherInfoView.swift
//  Weather
//
//  Created by Pavel Sharenda on 12/18/24.
//

import SwiftUI

/// A view that displays detailed weather information for a city
struct WeatherInfoView: View {
    // MARK: - Properties
    @State private var viewModel: WeatherInfoViewModel
    
    // MARK: - Layout Constants
    enum Layout {
        enum Icon {
            static let size: CGFloat = 123
        }
        
        enum CityName {
            static let fontSize: CGFloat = 30
            static let topPadding: CGFloat = 27
            static let iconSpacing: CGFloat = 11
            static let iconSize: CGFloat = 21
            static let font = "Poppins-SemiBold"
        }
        
        enum Temperature {
            static let fontSize: CGFloat = 70
            static let topPadding: CGFloat = 16
            static let degreeSymbolSize: CGFloat = 8
            static let degreeStrokeWidth: CGFloat = 2
            static let containerHeight: CGFloat = 70
            static let font = "Poppins-Medium"
        }
        
        enum Details {
            static let itemSpacing: CGFloat = 56
            static let containerWidth: CGFloat = 274
            static let containerHeight: CGFloat = 75
            static let cornerRadius: CGFloat = 16
            static let topPadding: CGFloat = 36
            static let labelFontSize: CGFloat = 12
            static let valueFontSize: CGFloat = 15
            static let font = "Poppins-Medium"
        }
        
        static let backgroundColor = Color(red: 242/255, green: 242/255, blue: 242/255)
    }
    
    // MARK: - Initialization
    init(viewModel: WeatherInfoViewModel) {
        _viewModel = State(wrappedValue: viewModel)
        Logger.info("Initializing WeatherInfoView for city: \(viewModel.city.name)")
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            weatherIcon
            cityHeader
                .padding(.top, Layout.CityName.topPadding)
            temperatureView
                .padding(.top, Layout.Temperature.topPadding)
            weatherDetailsContainer
                .padding(.top, Layout.Details.topPadding)
        }
        .task {
            Logger.debug("WeatherInfoView appeared for city: \(viewModel.city.name)")
            await viewModel.fetchWeather()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Weather information for \(viewModel.city.name)")
    }
    
    // MARK: - Subviews
    private var weatherIcon: some View {
        WeatherIconView(iconURL: viewModel.weather?.conditionIconURL)
            .frame(width: Layout.Icon.size, height: Layout.Icon.size)
    }
    
    private var cityHeader: some View {
        HStack(spacing: Layout.CityName.iconSpacing) {
            Text(viewModel.city.name)
                .font(.custom(Layout.CityName.font, size: Layout.CityName.fontSize))
                .accessibilityAddTraits(.isHeader)
            
            Image(systemName: "paperplane.fill")
                .resizable()
                .scaledToFill()
                .frame(
                    width: Layout.CityName.iconSize,
                    height: Layout.CityName.iconSize
                )
                .accessibilityHidden(true)
        }
    }
    
    private var temperatureView: some View {
        HStack(alignment: .top) {
            Text(viewModel.formattedTemperature)
                .font(.custom(Layout.Temperature.font, size: Layout.Temperature.fontSize))
            
            TemperatureDegreeSymbol()
        }
        .frame(height: Layout.Temperature.containerHeight)
        .accessibilityValue("\(viewModel.formattedTemperature) degrees")
    }
    
    private var weatherDetailsContainer: some View {
        HStack(alignment: .center, spacing: Layout.Details.itemSpacing) {
            WeatherDetailItem(
                label: "Humidity",
                value: viewModel.formattedHumidity
            )
            WeatherDetailItem(
                label: "UV",
                value: viewModel.formattedUVIndex
            )
            WeatherDetailItem(
                label: "Feels Like",
                value: viewModel.formattedFeelsLike
            )
        }
        .frame(
            width: Layout.Details.containerWidth,
            height: Layout.Details.containerHeight
        )
        .background(
            RoundedRectangle(cornerRadius: Layout.Details.cornerRadius)
                .fill(Layout.backgroundColor)
        )
    }
}

// MARK: - Supporting Views
private struct WeatherIconView: View {
    let iconURL: URL?
    
    var body: some View {
        AsyncImage(url: iconURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "cloud")
                .resizable()
                .scaledToFill()
        }
    }
}

private struct TemperatureDegreeSymbol: View {
    var body: some View {
        Circle()
            .strokeBorder(
                Color.black,
                lineWidth: WeatherInfoView.Layout.Temperature.degreeStrokeWidth
            )
            .frame(
                width: WeatherInfoView.Layout.Temperature.degreeSymbolSize,
                height: WeatherInfoView.Layout.Temperature.degreeSymbolSize
            )
    }
}

private struct WeatherDetailItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.custom(
                    WeatherInfoView.Layout.Details.font,
                    size: WeatherInfoView.Layout.Details.labelFontSize
                ))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.custom(
                    WeatherInfoView.Layout.Details.font,
                    size: WeatherInfoView.Layout.Details.valueFontSize
                ))
                .foregroundColor(Color(red: 154/255, green: 154/255, blue: 154/255))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

// MARK: - Preview
#Preview {
    WeatherInfoView(
        viewModel: WeatherInfoViewModel(
            city: City(
                name: "London",
                latitude: 51.5171,
                longitude: -0.1062
            ),
            getCityWeatherUseCase: GetCityWeatherUseCaseMock()
        )
    )
}

// MARK: - Formatted Values
extension WeatherInfoViewModel {
    var formattedTemperature: String {
        guard let temperature = weather?.temperature else {
            Logger.debug("Temperature not available for city: \(city.name)")
            return "--"
        }
        return "\(Int(temperature))"
    }
    
    var formattedHumidity: String {
        guard let humidity = weather?.humidity else {
            Logger.debug("Humidity not available for city: \(city.name)")
            return "--%"
        }
        return "\(Int(humidity))%"
    }
    
    var formattedUVIndex: String {
        guard let uvIndex = weather?.uvIndex else {
            Logger.debug("UV index not available for city: \(city.name)")
            return "--"
        }
        return "\(Int(uvIndex))"
    }
    
    var formattedFeelsLike: String {
        guard let feelsLike = weather?.feelsLikeTemperature else {
            Logger.debug("Feels like temperature not available for city: \(city.name)")
            return "--°"
        }
        return "\(Int(feelsLike))°"
    }
}
