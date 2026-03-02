import SwiftUI

struct DailyForecastView: View {
    
    let daily: [ForecastItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("5-DAY FORECAST")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            ForEach(daily, id: \.dt) { item in
                HStack {
                    
                    Text(formatDay(item.dt))
                        .foregroundColor(.white)
                        .frame(width: 60, alignment: .leading)
                    
                    Spacer()
                    
                    AsyncImage(url: iconURL(item.weather.first?.icon)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    Text("\(Int(item.main.temp))°")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(20)
    }
    
    private func formatDay(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func iconURL(_ icon: String?) -> URL? {
        guard let icon = icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
