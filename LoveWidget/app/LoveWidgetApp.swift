//
//  LoveWidgetApp.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct LoveWidgetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var mainViewModel = MainViewModel()
    @StateObject var friendsViewModel = FriendsViewModel()
    @StateObject var widgetViewModel = WidgetViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainViewModel)
                .environmentObject(friendsViewModel)
                .environmentObject(widgetViewModel)
                .environmentObject(loginViewModel)
        }
    }
}
