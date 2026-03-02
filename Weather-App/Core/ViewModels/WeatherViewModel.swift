import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await WeatherAPIClient.shared.fetchWeather(for: city)
            self.weather = result
        } catch {
            errorMessage = "Failed to fetch weather. Please try again."
        }
        
        isLoading = false
    }
}
