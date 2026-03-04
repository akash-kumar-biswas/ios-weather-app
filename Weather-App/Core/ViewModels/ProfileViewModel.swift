import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var profile: UserProfile?
    @Published var isLoading = false
    
    private let service = ProfileService()
    
    func loadProfile() async {
        isLoading = true
        do {
            profile = try await service.fetchProfile()
        } catch {
            print("Failed to load profile:", error)
        }
        isLoading = false
    }
    
    func saveProfile(_ profile: UserProfile) async {
        do {
            try await service.saveProfile(profile)
            self.profile = profile
        } catch {
            print("Failed to save profile:", error)
        }
    }
}
