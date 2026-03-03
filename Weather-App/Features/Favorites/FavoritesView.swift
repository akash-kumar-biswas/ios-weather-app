import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject private var favoritesVM = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            
            // MARK: - Background
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Title
                Text("Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top)
                
                if favoritesVM.favoriteCities.isEmpty {
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("No Favorites Yet")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.headline)
                        
                        Text("Add cities from the Weather tab.")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            
                            ForEach(favoritesVM.favoriteCities, id: \.self) { city in
                                
                                FavoriteCard(city: city) {
                                    appState.selectedCity = city
                                    appState.selectedTab = 0
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        Task {
                                            await favoritesVM.remove(city: city)
                                        }
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}
