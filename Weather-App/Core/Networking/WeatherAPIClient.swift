import Foundation

final class WeatherAPIClient {
    
    static let shared = WeatherAPIClient()
    
    private init() {}
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        
        let apiKey = APIKeys.openWeatherKey
        
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = """
        https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric
        """
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode(WeatherResponse.self, from: data)
        
        return weather
    }
    
    func fetchForecast(for city: String) async throws -> ForecastResponse {
        
        let apiKey = APIKeys.openWeatherKey
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = """
        https://api.openweathermap.org/data/2.5/forecast?q=\(encodedCity)&appid=\(apiKey)&units=metric
        """
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ForecastResponse.self, from: data)
    }
}
