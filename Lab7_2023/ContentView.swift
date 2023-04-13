//
//  ContentView.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

///The different tab views of the app.
enum TabSelection: Int {
    case Start
    case Game
    case Settings
}

///The main view of the app
///Updates the current tabSelection, based on user interaction.

struct ContentView: View {
    ///The currently selected tab view
    @State private var tabSelection: TabSelection = .Start
    
    ///The list of treasures that must be placed
    @EnvironmentObject var treasures : Treasures
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                StartView()
                    .tabItem {
                        Text("Start")
                    }
                    .tag(TabSelection.Start)
                
                GameView()
                    .tabItem {
                        Text("Game")
                    }
                    .tag(TabSelection.Game)
                
                SettingsView()
                    .tabItem {
                        Text("Settings")
                    }
                    .tag(TabSelection.Settings)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Treasures())
    }
}
