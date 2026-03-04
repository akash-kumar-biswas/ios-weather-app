import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ProfileService {

    private let db = Firestore.firestore()

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func saveProfile(_ profile: UserProfile) async throws {
        guard let uid = userId else { return }

        let data: [String: Any] = [
            "name": profile.name,
            "dateOfBirth": Timestamp(date: profile.dateOfBirth),
            "country": profile.country,
            "gender": profile.gender,
            "temperatureUnit": profile.temperatureUnit,
            "lastViewedCity": profile.lastViewedCity as Any,
            "createdAt": Timestamp(date: profile.createdAt)
        ]

        try await db.collection("users")
            .document(uid)
            .setData(data, merge: true)
    }

    func fetchProfile() async throws -> UserProfile? {
        guard let uid = userId else { return nil }

        let snapshot = try await db.collection("users")
            .document(uid)
            .getDocument()

        guard let data = snapshot.data() else { return nil }

        let name = data["name"] as? String ?? ""
        let dobTS = data["dateOfBirth"] as? Timestamp ?? Timestamp(date: Date())
        let country = data["country"] as? String ?? ""
        let gender = data["gender"] as? String ?? "Male"
        let unit = data["temperatureUnit"] as? String ?? "C"
        let lastCity = data["lastViewedCity"] as? String
        let createdTS = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())

        return UserProfile(
            name: name,
            dateOfBirth: dobTS.dateValue(),
            country: country,
            gender: gender,
            temperatureUnit: unit,
            lastViewedCity: lastCity,
            createdAt: createdTS.dateValue()
        )
    }
}
