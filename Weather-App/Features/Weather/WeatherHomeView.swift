import SwiftUI

struct WeatherHomeView: View {
    
    @StateObject private var weatherVM = WeatherViewModel()
    @State private var city = ""
    
    var body: some View {
        ZStack {
            
            // Background Gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Title
                Text("Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Search Bar
                HStack {
                    TextField("Search city...", text: $city)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(14)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                    
                    Button {
                        Task {
                            await weatherVM.fetchWeather(for: city)
                        }
                    } label: {
                        Image(systemName: "arrow.forward")
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(14)
                    }
                }
                
                if weatherVM.isLoading {
                    ProgressView()
                        .tint(.white)
                }
                
                if let error = weatherVM.errorMessage {
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                if let weather = weatherVM.weather {
                    WeatherCardView(weather: weather)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
