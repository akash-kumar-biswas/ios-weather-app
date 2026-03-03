import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Hourly (first 8 items ≈ 24 hours)
    var hourlyForecast: [ForecastItem] {
        Array(forecast?.list.prefix(8) ?? [])
    }
    
    // MARK: - Reliable Daily Forecast (5 days)
    var dailyForecast: [ForecastItem] {
        guard let forecast = forecast else { return [] }
        
        var seenDays: Set<String> = []
        var result: [ForecastItem] = []
        
        for item in forecast.list {
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dayString = formatter.string(from: date)
            
            if !seenDays.contains(dayString) {
                seenDays.insert(dayString)
                result.append(item)
            }
        }
        
        return Array(result.prefix(5))
    }
    
    // MARK: - Fetch Weather
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let current = WeatherAPIClient.shared.fetchWeather(for: city)
            async let forecastData = WeatherAPIClient.shared.fetchForecast(for: city)
            
            self.weather = try await current
            self.forecast = try await forecastData
            
        } catch {
            errorMessage = "Failed to fetch weather data."
        }
        
        isLoading = false
    }
    
    // for fetching weather of current location
    func fetchWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let current = WeatherAPIClient.shared
                .fetchWeather(latitude: latitude, longitude: longitude)
            
            async let forecastData = WeatherAPIClient.shared
                .fetchForecast(latitude: latitude, longitude: longitude)
            
            self.weather = try await current
            self.forecast = try await forecastData
            
        } catch {
            errorMessage = "Failed to fetch location weather."
        }
        
        isLoading = false
    }
}
