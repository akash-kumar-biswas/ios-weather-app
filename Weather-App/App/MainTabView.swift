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
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
    }
}
