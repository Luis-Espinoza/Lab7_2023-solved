//
//  StartView.swift
//  Lab7_2023
//
//  Created by IMD 224 on 2023-04-12.
//

import SwiftUI

///The view shown at the start of the app
struct StartView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("Welcome to the ICS 224 Memory Game!")
                Spacer()
                Text("The aim is to uncover identical images, without uncovering a mismatching image in the process. If a certain number of identical images have been revealed, they are removed from the game. (The exact number of identical images that must be uncovered before they are removed depends on the image, and can be set from the Settings tab.) If a mismatched image is selected, all revealed images are hidden again. The game ends when all images have been removed from the game.")
            }
        }
        .padding()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
