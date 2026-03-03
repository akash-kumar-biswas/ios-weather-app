import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            
            WeatherHomeView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(1)
            
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
            .tag(2)
        }
    }
}
