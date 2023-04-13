//
//  Treasures.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import Foundation
import os

/// The list of treasures
class Treasures: ObservableObject {
    ///The URL where treasures are loaded from/saved to
    static let listUrl = FileManager().urls(for:.documentDirectory, in: .userDomainMask).first!.appendingPathComponent("entries")
    
    ///The list of treasures
    @Published var list = [Treasure]()
    
    ///Attempts to load the list of treasures, if that fails, list is set to an empty array of treasures
    init() {
        loadObjects()
    }
    
    ///Attempts to load the list of treasures from listUrl. On failure, the list is not updated
    func loadObjects() {
        do {
            let data = try Data(contentsOf: Treasures.listUrl)
            list = try JSONDecoder().decode([Treasure].self, from: data)
        } catch {
            os_log("Cannot load due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
        }
    }
    
    ///Attempts to save the list of treasures to listUrl. On failure, nothing is saved
    func saveObjects() {
        do {
            let data = try JSONEncoder().encode(list)
            try data.write(to: Treasures.listUrl)
        } catch {
            os_log("Cannot save due to %@", log: OSLog.default, type: .debug, error.localizedDescription)
        }
    }
}
