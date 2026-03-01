//
//  MainTabView.swift
//  Weather-App
//
//  Created by macos on 1/3/26.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Weather Screen")
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }

            Text("Favorites Screen")
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }

            Text("Profile Screen")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
