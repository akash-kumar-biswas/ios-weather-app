import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    private var userEmail: String {
        Auth.auth().currentUser?.email ?? "No Email"
    }
    
    var body: some View {
        ZStack {
            
            // MARK: - Background
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: - Title
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Spacer()
                
                // MARK: - Profile Card
                VStack(spacing: 20) {
                    
                    // Avatar
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Email
                    VStack(spacing: 5) {
                        Text("Logged in as")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(userEmail)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.15))
                        .background(.ultraThinMaterial)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Logout Button
                Button {
                    authVM.signOut()
                } label: {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}
