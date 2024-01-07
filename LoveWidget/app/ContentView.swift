//
//  ContentView.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import SwiftyStoreKit

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    var body: some View {
        ZStack {
            
            switch mainViewModel.SCREEN_VIEW {
            case .MainMenu:
                MainScreen()
            case .Friends:
                FriendsScreen()
            case .WidgetSingle:
                WidgetSingleScreen()
            case .Login:
                LoginScreen()
            case .History:
                WidgetHistoryScreen()
            case .CreateWidget:
                CreateWidgetScreen()
            case .UploadImageScreen:
                UploadImageScreen()
            case .EditQuoteScreen:
                EditQuoteScreen()
            case .SignUp:
                SignupScreen()
            case .ForgetPasswordScreen:
                ForgetPasswordScreen()
            case .ResetPasswordScreen:
                ResetPasswordScreen()
            case .Profile:
                ProfileScreen()
            case .Purchase:
                PurchaseScreen()
            case .EditImage:
                EditImageScreen()
            case .ImageCropperView:
                ImageCropperScreen()
            case .OnBoarding:
                OnBoardingScreen()
            case .Drawing:
                DrawScreen()
            }
            
            
        }.onAppear {
            if isUserLoggedIn() {
                mainViewModel.SCREEN_VIEW = .MainMenu
            } else {
                mainViewModel.SCREEN_VIEW = .Login
            }
            
            if !didUserWatchOnBoarding() {
                mainViewModel.SCREEN_VIEW = .OnBoarding
            }
            
            retrieveProducts()
        }
    }
    
    func retrieveProducts() {
        
        SwiftyStoreKit.retrieveProductsInfo(["Monthly__Subscription","Yearly_Subscription","Lifetime"]) { result in
            
            for i in result.retrievedProducts {
                for j in 0..<purchaseIds.count {
                    if i.productIdentifier == purchaseIds[j] {
                        purchaseIds[j] = i.localizedPrice ?? "$$$"
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
