//
//  GameView.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

///The game view of the app.
///Set up the collection of tiles every time this view appears.
///Modifies the currently-placed collection of tiles, as treasures are correctly selected.
struct GameView: View {
    ///The degree of opacity to indicate the move animation is complete
    static let fullyVisible = 1.0
    
    ///The degree of opacity to indicate the move animation is not yet complete
    static let somewhatVisible = 0.5
    
    ///The size of each tile
    static let tileSize = 20.0
    
    ///The game board, consisting of a collection of tiles
    @StateObject private var tiles = Tiles()
    
    ///The list of treasures that must be placed
    @EnvironmentObject var treasures : Treasures
    
    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                VStack {
                    ForEach(0..<tiles.numRows, id: \.self) { i in
                        HStack {
                            ForEach(0..<tiles.numCols, id: \.self) { j in
                                Image(systemName: tiles.showTreasureAt(row: i, column: j))
                                    .disabled(tiles.updating)
                                    .frame(width: GameView.tileSize, height: GameView.tileSize, alignment: .center)
                                    .onTapGesture {
                                        tiles.revealTreasureAt(row: i, column: j)
                                    }
                                    .opacity(tiles.updating ? GameView.somewhatVisible : GameView.fullyVisible)
                            }
                        }
                    }
                    Spacer()
                    Text("Attempts: \(tiles.numReveals)")
                    if tiles.totalRemaining > 0 {
                        Text("Total Remaining: \(tiles.totalRemaining)")
                    }
                    else {
                        Text("Game Over")
                    }
                }
                .padding()
            }
            .onAppear() {
                tiles.setupBoard(treasureList: treasures.list)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(Treasures())
    }
}
