import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        TabView {
            
            Text("Weather Screen")
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
            
            Text("Favorites Screen")
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.title)
                
                Button("Logout") {
                    authVM.signOut()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
