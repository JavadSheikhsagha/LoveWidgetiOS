//
//  LoveWidgetApp.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import FirebaseCore
import SwiftUI
import OneSignalFramework
import OneSignalUser


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // Remove this method to stop OneSignal Debugging
        FirebaseApp.configure()
        
        
        OneSignal.Debug.setLogLevel(.LL_FATAL)
       OneSignal.initialize("11e4a8c0-931b-481e-a40b-1b3cace50c35",
                            withLaunchOptions: launchOptions)
       OneSignal.Notifications.requestPermission({ accepted in
         print("User accepted notifications: \(accepted)")
       }, fallbackToSettings: true)
        
        
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
                .preferredColorScheme(.light)
                .environmentObject(mainViewModel)
                .environmentObject(friendsViewModel)
                .environmentObject(widgetViewModel)
                .environmentObject(loginViewModel)
        }
    }
}
