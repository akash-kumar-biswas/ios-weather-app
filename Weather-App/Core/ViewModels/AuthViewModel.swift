
import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        self.user = Auth.auth().currentUser
        
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth()
                .createUser(withEmail: email, password: password)
            self.user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth()
                .signIn(withEmail: email, password: password)
            self.user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
