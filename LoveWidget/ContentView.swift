//
//  ContentView.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LoginScreen()
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
