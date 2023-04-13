//
//  SettingsView.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

///The settings view of the app.
///Updates the list of treasures and the associated rules regarding treasure-specific group size and number of groups for use by the game.
///The list of treasures is saved when this view disappears.
struct SettingsView: View {
    ///The minimum number of matching tiles that must be guessed before they are removed. Used by the group size stepper
    let minGroupSize = 2
    
    ///The maximum number of matching tiles that must be guessed before they are removed. Used by the group size stepper
    let maxGroupSize = 10
    
    ///The minimum number of groups that a particular type of tile can form. Used by the number of groups stepper
    let minNumGroupSize = 1
    
    ///The maximum number of groups that a particular type of tile can form. Used by the number of groups stepper
    let maxNumGroupSize = 10
    
    ///The minimum size that the settings list can take
    let minScrollViewSize = 800.0
    
    ///The minimum size that the stepper can take
    let minStepperViewSize = 450.0
    
    ///The list of treasures that must be placed
    @EnvironmentObject var treasures : Treasures
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView([.horizontal]) {
                    List {
                        ForEach($treasures.list) {
                            $treasure in
                            HStack {
                                TextField("Icon Name", text: $treasure.name)
                                    .autocapitalization(.none)
                                    .padding()
                                Spacer()
                                
                                HStack {
                                    Text("\(treasure.groupSize)/group")
                                        .lineLimit(1)
                                    Stepper("Group Size", value: $treasure.groupSize, in: minGroupSize...maxGroupSize, step: 1)
                                        .labelsHidden()
                                        .padding()
                                    
                                    Text("\(treasure.numGroups) group\(treasure.numGroups == 1 ? " " : "s")")
                                    Stepper("Group Number", value: $treasure.numGroups, in: minNumGroupSize...maxNumGroupSize, step:1)
                                        .labelsHidden()
                                        .padding()
                                }
                                .frame(minWidth: minStepperViewSize)
                            }
                        }
                        .onDelete {
                            if let index = $0.first {
                                treasures.list.remove(at: index)
                            }
                        }
                        .onMove {
                            treasures.list.move(fromOffsets: $0, toOffset: $1)
                        }
                    }
                    .frame(width: max(minScrollViewSize, geo.size.width), height: geo.size.height, alignment: .center)
                }
            }
            .navigationBarTitle("Treasures")
            .toolbar {
                HStack {
                    EditButton()
                    Button(
                        action: {
                            treasures.list.insert(Treasure(name: "", groupSize: minGroupSize, numGroups: minNumGroupSize), at: 0)
                        },
                        label: {
                            Image(systemName: "plus")
                        })
                }
            }
        }
        .navigationViewStyle(.stack)
        .onDisappear() {
            treasures.saveObjects()
        }
    }
}
