import SwiftUI

struct HourlyForecastView: View {
    
    let hourly: [ForecastItem]
    var temperatureUnit: String = "C"
    
    private var unitSymbol: String { temperatureUnit == "F" ? "°F" : "°C" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("HOURLY FORECAST")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    
                    ForEach(hourly, id: \.dt) { item in
                        VStack(spacing: 10) {
                            
                            Text(formatHour(item.dt))
                                .foregroundColor(.white)
                                .font(.caption)
                            
                            AsyncImage(url: iconURL(item.weather.first?.icon)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("\(Int(item.main.temp))\(unitSymbol)")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(20)
    }
    
    private func formatHour(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
    
    private func iconURL(_ icon: String?) -> URL? {
        guard let icon = icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
