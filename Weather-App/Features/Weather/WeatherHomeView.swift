import SwiftUI

struct WeatherHomeView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var weatherVM = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @State private var city = ""
    @State private var hasLoadedInitialWeather = false
    
    // Converts the stored "C"/"F" preference to the API units string
    private var apiUnits: String {
        appState.temperatureUnit == "F" ? "imperial" : "metric"
    }
    
    // Symbol shown next to the temperature
    private var unitSymbol: String {
        appState.temperatureUnit == "F" ? "°F" : "°C"
    }
    
    var body: some View {
        ZStack {
            
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
                                await weatherVM.fetchWeather(for: city, units: apiUnits)
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
                            
                            Text("\(Int(weather.main.temp))\(unitSymbol)")
                                .font(.system(size: 90, weight: .thin))
                                .foregroundColor(.white)
                            
                            Text(weather.weather.first?.description.capitalized ?? "")
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("H: \(Int(weather.main.temp + 2))\(unitSymbol)  L: \(Int(weather.main.temp - 3))\(unitSymbol)")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 30)
                        
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
                        
                        HourlyForecastView(hourly: weatherVM.hourlyForecast, temperatureUnit: appState.temperatureUnit)
                        DailyForecastView(daily: weatherVM.dailyForecast, temperatureUnit: appState.temperatureUnit)
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
                
                // Favorite city selection
                .onChange(of: appState.selectedCity) { selectedCity in
                    if let selectedCity = selectedCity {
                        city = selectedCity
                        Task {
                            await weatherVM.fetchWeather(for: selectedCity, units: apiUnits)
                        }
                    }
                }
                // Re-fetch when the user switches temperature unit
                .onChange(of: appState.temperatureUnit) { _ in
                    guard !city.isEmpty else { return }
                    Task {
                        await weatherVM.fetchWeather(for: city, units: apiUnits)
                    }
                }
            }
            
            // Load location ONLY once
            .onAppear {
                if !hasLoadedInitialWeather {
                    hasLoadedInitialWeather = true
                    locationManager.requestLocation()
                }
            }
            
            // Fetch weather when location updates
            .onChange(of: locationManager.location) { location in
                if let location = location {
                    Task {
                        await weatherVM.fetchWeather(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            units: apiUnits
                        )
                    }
                } else {
                    // fallback only if location truly unavailable
                    Task {
                        await weatherVM.fetchWeather(for: "Khulna", units: apiUnits)
                    }
                }
            }
        }
    }
}
