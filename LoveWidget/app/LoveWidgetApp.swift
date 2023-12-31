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
import SwiftyStoreKit


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        setIsPro(true)
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    }
                }
            }
        
        FirebaseApp.configure()
        
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
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
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(mainViewModel)
                .environmentObject(friendsViewModel)
                .environmentObject(widgetViewModel)
                .environmentObject(loginViewModel)
                .environmentObject(appState)
                .onLoad {
                    mainViewModel.notifyFriends { bool in
                        
                    }
                }
        }
    }
}

extension View {

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }

}

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}
