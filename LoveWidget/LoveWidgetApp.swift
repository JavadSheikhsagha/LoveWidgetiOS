//
//  LoveWidgetApp.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI

@main
struct LoveWidgetApp: App {
    
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    @StateObject var widgetViewModel = WidgetViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainViewModel)
                .environmentObject(friendsViewModel)
                .environmentObject(widgetViewModel)
        }
    }
}
