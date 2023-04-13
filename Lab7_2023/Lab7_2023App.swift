//
//  Lab7_2023App.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

@main
///The main entry point to the app.
///The list of treasures that must be placed is loaded on startup, and saved if placing the app into the background
///or when navigating away from the settings view.
///Game state is neither loaded nor saved, but is reset every time the game view is entered.
struct Lab7_2023App: App {
    ///The current phase of the app (e.g., background)
    @Environment(\.scenePhase) var scenePhase
    
    ///The list of treasures that must be placed on the board
    @StateObject private var treasures = Treasures()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(treasures)
        }
        .onChange(of: scenePhase) {
            phase in
            switch phase {
            case .background:
                treasures.saveObjects()
            default:
                break
            }
        }
    }
}
