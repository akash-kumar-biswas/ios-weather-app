import SwiftUI

struct WeatherHomeView: View {
    
    @StateObject private var weatherVM = WeatherViewModel()
    @State private var city = ""
    
    var body: some View {
        ZStack {
            
            // Sky Background
            LinearGradient(
                colors: [Color.blue, Color.blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // MARK: - Search
                    HStack {
                        TextField("Search city...", text: $city)
                            .padding()
                            .background(Color.white.opacity(0.25))
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                        
                        Button {
                            Task {
                                await weatherVM.fetchWeather(for: city)
                            }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                    }
                    
                    if let weather = weatherVM.weather {
                        
                        // MARK: - Header Section (Apple Style)
                        VStack(spacing: 8) {
                            
                            Text(weather.name)
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(Int(weather.main.temp))°")
                                .font(.system(size: 90, weight: .thin))
                                .foregroundColor(.white)
                            
                            Text(weather.weather.first?.description.capitalized ?? "")
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("H: \(Int(weather.main.temp + 2))°  L: \(Int(weather.main.temp - 3))°")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 30)
                        
                        // MARK: - Hourly Forecast (Next Step will fill properly)
                        HourlyForecastView(hourly: weatherVM.hourlyForecast)
                    }
                    
                    DailyForecastView(daily: weatherVM.dailyForecast)
                    
                    if weatherVM.isLoading {
                        ProgressView()
                            .tint(.white)
                            .padding()
                    }
                    
                    if let error = weatherVM.errorMessage {
                        Text(error)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                }
                .padding()
            }
        }
    }
}
