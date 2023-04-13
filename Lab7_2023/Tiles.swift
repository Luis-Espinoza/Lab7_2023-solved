//
//  Tiles.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

///Contains the collection of tiles, making up the current game board.
class Tiles: ObservableObject {
    ///The actual board
    @Published var board: [[Tile]] = [[Tile()]]
    
    ///Number of columns
    @Published var numCols: Int = 1
    
    ///Number of rows
    @Published var numRows: Int = 1
    
    ///The total number of revelations so far. This is updated every time a hidden tile is revealed
    @Published var numReveals = 0
    
    ///The tiles that have been selected as part of the current streak
    private var currentStreakTiles = [(Int, Int)]()
    
    ///The current type of treasure that must be selected; an empty string indicates N/A
    private var currentTileType = ""
    
    ///The number of identical treasures that must still be picked
    private var requiredRemaining = 0
    
    ///The number of remaining treasures
    @Published var totalRemaining = 0
    
    ///Whether or not the board is being updated; no changes are allowed during an update
    @Published var updating = false
    
    ///Sets up a new board with all treasures randomly placed.
    ///numReveals is reset to 0
    ///totalRemaining is set to the number of placed treasures.
    ///numRows and numCols is set so that all treasures can be placed in a square grid.
    ///A new board of size numRows x numCols is created is created.
    ///All the treasures in treasureList are randomly placed onto the board.
    /// -Parameters:
    ///     -treasureList: The list of treasures
    func setupBoard(treasureList: [Treasure]) {
        numReveals = 0
        
        //Figure out board dimensions
        totalRemaining = treasureList.reduce(0) {partialResult, currentTreasure in
            return partialResult + currentTreasure.groupSize * currentTreasure.numGroups
        }
        let dimension = Int(ceil(sqrt(Double(totalRemaining))))
        numRows = dimension
        numCols = dimension
        
        //Initialize a board with blank tiles
        board = [[Tile]]()
        board = Array(repeating: Array(repeating: Tile(), count: dimension), count: dimension)
        
        //Create a list of all treasures
        var tmpArray = [Treasure]()
        for treasure in treasureList {
            tmpArray += Array(repeating: treasure, count: treasure.groupSize * treasure.numGroups)
        }
        
        //Add blanks where necessary to map onto the board 1:1
        let remnant = dimension * dimension - tmpArray.count
        if remnant > 0 {
            tmpArray += Array(repeating: Treasure(name: emptyTileName, groupSize: 1, numGroups: 1), count: remnant)
        }
        
        //Shuffle
        tmpArray.shuffle()
        
        //Assign the elements to the board
        for row in 0..<dimension {
            for col in 0..<dimension {
                board[row][col].contents = tmpArray.popLast()!
            }
        }
    }
    
    ///Returns the name of the of the tile at the given row and column. Tile.empty.name is returned if the location is invalid
    ///- Parameters:
    ///     - row: The row of the tile
    ///     - column: The column of the tile
    ///- Returns: The sought-after tile name, or Tile.empty.name if row and/or column are out of range
    func showTreasureAt(row: Int, column: Int) -> String {
        if (row < 0) || (numRows <= row) || (column < 0) || (numCols <= column) {
            return Tile.empty.name
        }
        return board[row][column].icon.name
    }
    
    ///Sets the reveal status of the tile at the given row and column to true.
    ///If updating is true, this function simply returns.
    ///Otherwise, updating is set to true until this function, and its deferred asyncs, terminate.
    ///If the row and/or column is invalid, this function simply returns.
    ///numReveals is incremented by 1
    ///currentTileType, requiredRemaining, and currentStreakTiles will be updated to track the current reveal streak
    ///If the needed number of identical tiles have been revealed, they will be replaced by empty tiles on the board, and totalRemaining will be decremented
    ///accordingly.
    ///-Parameters:
    ///     -row: The row of the tile
    ///     -column: The column of the tile
    func revealTreasureAt(row: Int, column: Int){
        if updating {
            return
        }
        updating = true
        
        if (row < 0) || (numRows <= row) || (column < 0) || (numCols <= column) || (totalRemaining == 0) {
            updating = false
            return
        }
        
        numReveals += 1
        if board[row][column].revealed {
            //Too bad, this tile has already been revealed
            updating = false
            return
        }
        board[row][column].revealed = true
        
        if currentTileType == "" && board[row][column].contents.name != Tile.empty.name {
            //Start of new tile streak
            currentStreakTiles = [(row,column)]
            currentTileType = board[row][column].contents.name
            requiredRemaining = board[row][column].contents.groupSize - 1
            updating = false
            return
        }
        
        if currentTileType == board[row][column].contents.name && board[row][column].contents.name != Tile.empty.name {
            //Got the next matching slide
            currentStreakTiles.append((row,column))
            requiredRemaining -= 1
            if requiredRemaining != 0 {
                updating = false
            }
            else {
                //Found a complete streak
                self.currentTileType = ""
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    for (r,c) in self.currentStreakTiles {
                        self.board[r][c].contents = Tile.empty
                        self.totalRemaining -= 1
                    }
                    self.currentStreakTiles = [(Int, Int)]()
                    self.updating = false
                }
            }
            return
        }
        
        //We have a mismatch
        self.currentTileType = ""
        self.requiredRemaining = 0
        if self.board[row][column].contents.name != Tile.empty.name {
            //Hide non-empty tiles again
            self.currentStreakTiles.append((row,column))
        }
        if currentStreakTiles.isEmpty {
            updating = false
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                for(r,c) in self.currentStreakTiles {
                    self.board[r][c].revealed = false
                }
                self.currentStreakTiles = [(Int, Int)]()
                self.updating = false
            }
        }
    }
}
