//
//  Treasure.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import Foundation

///A single item of treasure
struct Treasure : Codable, Hashable, Identifiable {
    ///The unique ID
    var id = UUID()
    
    ///The name of the treasure; must match a string found in SF Symbol
    var name: String
    
    ///The number of identical images that must be picked before the treasure is removed from the board
    var groupSize: Int
    
    ///groupSize x numGroups == number of times this image will be placed on the board initially
    var numGroups: Int
}
