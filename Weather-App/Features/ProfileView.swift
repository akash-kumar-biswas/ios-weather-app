import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()
    
    @State private var name = ""
    @State private var dateOfBirth = Date()
    @State private var country = ""
    @State private var gender = "Male"
    @State private var temperatureUnit = "C"
    
    let genders = ["Male", "Female", "Other"]
    
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
                    
                    Text("Profile")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    // MARK: Account Section
                    VStack(spacing: 15) {
                        
                        Text(authVM.user?.email ?? "")
                            .foregroundColor(.white)
                        
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        
                        DatePicker("Date of Birth",
                                   selection: $dateOfBirth,
                                   displayedComponents: .date)
                            .foregroundColor(.white)
                        
                        TextField("Country", text: $country)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(genders, id: \.self) { g in
                                Text(g)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Button("Save Profile") {
                            Task {
                                let profile = UserProfile(
                                    name: name,
                                    dateOfBirth: dateOfBirth,
                                    country: country,
                                    gender: gender,
                                    temperatureUnit: temperatureUnit,
                                    lastViewedCity: nil,
                                    createdAt: Date()
                                )
                                await profileVM.saveProfile(profile)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                    
                    // MARK: Preferences
                    VStack(spacing: 10) {
                        
                        Toggle("Use Celsius", isOn: Binding(
                            get: { temperatureUnit == "C" },
                            set: { temperatureUnit = $0 ? "C" : "F" }
                        ))
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                    
                    // MARK: Activity
                    VStack(spacing: 10) {
                        
                        HStack {
                            Text("Total Favorites")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(favoritesVM.favoriteCities.count)")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                    
                    // MARK: Logout
                    Button {
                        authVM.signOut()
                    } label: {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            
            Task {
                await profileVM.loadProfile()
                if let profile = profileVM.profile {
                    name = profile.name
                    dateOfBirth = profile.dateOfBirth
                    country = profile.country
                    gender = profile.gender
                    temperatureUnit = profile.temperatureUnit
                }
            }
        }
        .onChange(of: temperatureUnit) { _ in
            Task {
                let created = profileVM.profile?.createdAt ?? Date()
                let updated = UserProfile(
                    name: name,
                    dateOfBirth: dateOfBirth,
                    country: country,
                    gender: gender,
                    temperatureUnit: temperatureUnit,
                    lastViewedCity: profileVM.profile?.lastViewedCity,
                    createdAt: created
                )
                await profileVM.saveProfile(updated)
            }
        }
    }
}
