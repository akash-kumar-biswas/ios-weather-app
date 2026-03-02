import Foundation

enum APIKeys {
    static var openWeatherKey: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["OPENWEATHER_API_KEY"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return value
    }
}
