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
    
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
      // Remove this method to stop OneSignal Debugging
      OneSignal.Debug.setLogLevel(.LL_DEBUG)
       
      // OneSignal initialization
      OneSignal.initialize("11e4a8c0-931b-481e-a40b-1b3cace50c35", withLaunchOptions: launchOptions)

      // requestPermission will show the native iOS notification permission prompt.
      // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
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
                .environmentObject(mainViewModel)
                .environmentObject(friendsViewModel)
                .environmentObject(widgetViewModel)
                .environmentObject(loginViewModel)
        }
    }
}
