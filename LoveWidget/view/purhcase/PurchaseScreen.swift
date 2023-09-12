//
//  PurchaseScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/11/23.
//

import SwiftUI
import SwiftyStoreKit
import EnigmaSystemDesign

var purchaseIds : [String] = [
    "Monthly__Subscription",
    "Yearly_Subscription",
    "Lifetime",
]

struct PurchaseScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var errorMessage:String = ""
    @State var showError = false
    @State var showIndicator = false
    @State var showSubTerms = false
    
    var titles = [
        "Unlimited notification",
        "Unlimited adding quote",
        "Unlimited adding image",
        "Unlimited friends",
        "Remove ads",
    ]
    
    var purchaseList = [
        PurchaseModel(title: "Premium 1 Month ", 
                      description: "Premium features are available.",
                      identifier: "Monthly__Subscription"),
        PurchaseModel(title: "Premium 1 Year + Family Sharing ",
                      description: "Compared to 1 Month (Save 75%)",
                      identifier: "Yearly_Subscription"),
        PurchaseModel(title: "Lifetime + Family Sharing ",
                      description: "Compared to 1 Month (Save 90%)",
                      identifier: "Lifetime"),
    ]
    
    var body: some View {
        ZStack {
            
            Image(.purchaseBackground)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                header
                
                titlesView
                
                purchaseCards
                
                Spacer()
                
                HStack {
                    
                    Link(destination: URL(string: "https://doc-hosting.flycricket.io/love-noteit-widget-by-sendit-privacy-policy/2ad76052-1031-414a-b241-1786eda6f863/privacy")!) {
                        Text("Privacy Policy")
                            .foregroundStyle(.gray)
                            .font(.system(size: 13))
                    }
                    
                    Spacer()
                    
                    Button {
                        showSubTerms = true
                    } label: {
                        Text("Subscription Terms")
                            .foregroundStyle(.gray)
                            .font(.system(size: 13))
                    }

                    
                    Spacer()
                    
                    Link(destination: URL(string: "https://doc-hosting.flycricket.io/love-noteit-widget-by-sendit-terms-of-use/1f962d22-bfab-4da0-b166-ca8a347f8ee1/terms")!) {
                        Text("Terms of use")
                            .foregroundStyle(.gray)
                            .font(.system(size: 13))
                    }
                    
                }.padding(.horizontal, 26)
                
                Spacer()
            }
            
            ActivityIndicator(isAnimating: $showError, style: .large)
                .opacity(showIndicator ? 1.0 : 0.0)
                .offset(y: showIndicator ? 0.0 : UIScreen.screenHeight)
            
        }
        .alert("Subscription Terms", isPresented: $showSubTerms, actions: {
            Button("ok") {
                
            }
        }, message: {
            Text("- Subscription automatically renews unless auto-renew is turned off at least\n24-hours before the end of the current period.\n - Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal.\n- Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's")
        })
        .alert(errorMessage, isPresented: $showError) {
            Button("ok") {
                
            }
        }
    }
    
    var purchaseCards : some View {
        VStack {
            Spacer()
                .frame(height: 24)
            
            ForEach(0..<purchaseIds.count, id: \.self) { purchase in
                Button {
                    // purchase
                    showIndicator = true
                    purchaseItem(purchaseId: purchaseList[purchase].identifier)
                } label: {
                    VStack {
                        
                        Spacer()
                            .frame(height: 18)
                        
                        ZStack {
                            
                            Color(hex: "#C7C7C7")
                                .opacity(0.2)
                                
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(purchaseList[purchase].title)
                                      .font(
                                        Font.custom("SF Pro Rounded", size: 16)
                                          .weight(.bold)
                                      )
                                      .bold()
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(Color(red: 0.98, green: 0.98, blue: 0.99))
                                    
                                    HStack {
                                        
                                        Circle()
                                            .foregroundStyle(Color(hex: "#C7C7C7"))
                                            .frame(width: 4, height: 4)
                                        
                                        Text(purchaseList[purchase].description)
                                            .font(.system(size: 14))
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                                    }
                                }
                                
                                Spacer()
                                
                                Text(purchaseIds[purchase])
                                    .foregroundStyle(.white)
                                    .bold()
                                    .font(.system(size: 16))
                                
                            }
                            .padding(.horizontal, 20)
                            
                        }.frame(width: UIScreen.screenWidth - 40, height: 70)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 2)
                            )
                        
                    }
                }

            }
        }
    }
    
    var titlesView : some View {
        VStack {
            Spacer()
                .frame(height: 36)
            
            Image(.purchaseIllustration)
            
            Spacer()
                .frame(height: 16)
            
            VStack(spacing: 16) {
                
                ForEach(titles, id: \.self) { text in
                    HStack {
                        
                        Image(.puchaseTick)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Text(text)
                            .fontWeight(.black)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16))
                        
                    }
                }
                
            }
        }
    }
    
    var header : some View {
        HStack {
            
            Button {
                withAnimation {
                    mainViewModel.SCREEN_VIEW = mainViewModel.BACKSTACK_PURCHASE ?? .MainMenu
                }
            } label: {
                Image(.purchaseBack)
                    .frame(width: 24, height: 24)
            }

            Spacer()
            
            Text("Love Widget")
                .bold()
                .foregroundStyle(Color(red: 1, green: 0.55, blue: 0.55))
                .font(.system(size: 16))
                .offset(x: 36)
            
            Spacer()
            
            Button {
                //Restore
                restoreProducts()
            } label: {
                Text("RESTORE")
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: "#FF6868"))
            }

        }.padding(.horizontal, 16)
    }
    
    func restoreProducts() {
        showIndicator = true
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            showIndicator = false
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                showError = true
                errorMessage = "Restoration failed. \(results.restoreFailedPurchases)"
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                setIsPro(true)
                showError = true
                errorMessage = "Restored Successfully."
            }
            else {
                print("Nothing to Restore")
                showError = true
                errorMessage = "Nothing to Restore"
            }
        }
    }
    
    func purchaseItem(purchaseId: String) {
        SwiftyStoreKit.purchaseProduct(purchaseId, atomically: true) { result in
            
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                setIsPro(true)
                showIndicator = false
//                verifyReceipt(item: purchaseId)
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            case .error(let error):
                showError = true
                showIndicator = false
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                    errorMessage = "Unknown error. Please contact support"
                case .clientInvalid: print("Not allowed to make the payment")
                    errorMessage = "Not allowed to make the payment"
                case .paymentCancelled:
                    errorMessage = "Payment cancelled"
                case .paymentInvalid: print("The purchase identifier was invalid")
                    errorMessage = "The purchase identifier was invalid"
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                    errorMessage = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                    errorMessage = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                    errorMessage = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                    errorMessage = "Could not connect to the network"
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                    errorMessage = "User has revoked permission to use this cloud service"
                default: print((error as NSError).localizedDescription)
                }
            case .deferred(purchase: let purchase):
                break
            }
        }
    }
    
    func verifyReceipt(item: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = item
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    setIsPro(true)
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    setIsPro(false)
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}

#Preview {
    PurchaseScreen()
}

struct PurchaseModel {
    
    let title: String
    let description : String
    let identifier : String
}
