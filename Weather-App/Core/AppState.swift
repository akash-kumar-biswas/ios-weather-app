import Foundation
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    
    @Published var selectedTab: Int = 0
    @Published var selectedCity: String?
}
