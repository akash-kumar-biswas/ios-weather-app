import SwiftUI

struct WeatherHomeView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var weatherVM = WeatherViewModel()
    @State private var city = ""
    
    var body: some View {
        ZStack {
            
            // MARK: - Background
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
                    
                    // MARK: - Weather Content
                    if let weather = weatherVM.weather {
                        
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
                        
                        // MARK: - Add to Favorites Button
                        Button {
                            Task {
                                await favoritesVM.add(city: weather.name)
                            }
                        } label: {
                            Label("Add to Favorites", systemImage: "star.fill")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.yellow.opacity(0.9))
                                .foregroundColor(.black)
                                .cornerRadius(15)
                        }
                        .padding(.top, 10)
                        
                        // MARK: - Hourly Forecast
                        HourlyForecastView(hourly: weatherVM.hourlyForecast)
                        
                        // MARK: - Daily Forecast
                        DailyForecastView(daily: weatherVM.dailyForecast)
                    }
                    
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
                .onChange(of: appState.selectedCity) { selectedCity in
                    if let selectedCity = selectedCity {
                        city = selectedCity
                        Task {
                            await weatherVM.fetchWeather(for: selectedCity)
                        }
                    }
                }
            }
        }
    }
}
