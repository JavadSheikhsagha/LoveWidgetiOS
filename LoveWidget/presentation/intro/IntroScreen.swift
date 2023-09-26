//
//  IntroScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/9/23.
//

import SwiftUI
import _AVKit_SwiftUI

struct IntroScreen: View {
    
    @State var player = AVPlayer(url:  Bundle.main.url(forResource: "intro_vid", withExtension: "mp4")!)
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .onAppear(perform: {
                    player.play()
                    player.rate = 1.5
                })
            
            VideoPlayer(player: player)
                .frame(height: UIScreen.screenHeight)
            
            Color(hex: "")
                .ignoresSafeArea()
                .onTapGesture {
                    
                }
            
        }
    }
}

#Preview {
    IntroScreen()
}
