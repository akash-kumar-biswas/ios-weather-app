import Foundation

struct UserProfile: Codable {
    var name: String
    var dateOfBirth: Date
    var country: String
    var gender: String
    var temperatureUnit: String
    var lastViewedCity: String?
    var createdAt: Date
}
