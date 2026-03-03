import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteCities: [String] = []
    
    private let service = FavoritesService()
    
    init() {
        listen()
    }
    
    private func listen() {
        service.listenFavorites { [weak self] cities in
            self?.favoriteCities = cities
        }
    }
    
    func add(city: String) async {
        try? await service.addFavorite(city: city)
    }
    
    func remove(city: String) async {
        try? await service.removeFavorite(city: city)
    }
}
