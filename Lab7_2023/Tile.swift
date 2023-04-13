//
//  Tile.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import Foundation

///The icon used to designate an empty tile
let emptyTileName = "circle"

///The icon used to designate an unexplored tile
let unexploredTileName = "circle.fill"

///Describes an individual tile on the board
struct Tile: Identifiable {
    ///An empty tile
    static let empty = Treasure(name: emptyTileName, groupSize: 0, numGroups: 0)
    
    ///An unexplored tile
    static let unexplored = Treasure(name: unexploredTileName, groupSize: 0, numGroups: 0)
    
    ///Unique tile ID
    var id = UUID()
    
    ///Tile contents (default is empty)
    var contents = empty
    
    ///Whether the tile has been revealed or not
    var revealed = false
    
    ///The tile contents if the tile has been explored, else Tile.unexplored
    var icon : Treasure {
        get {
            revealed ? contents : Tile.unexplored
        }
    }
}
