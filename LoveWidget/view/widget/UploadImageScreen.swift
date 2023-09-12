//
//  DonePhotoWidgetScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/2/23.
//

import SwiftUI
import LottieSwiftUI

struct UploadImageScreen: View {
    
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var playLottie = true
    
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                chosenImage
                
                bottomButtons
                
            }
            
            Color.white
                .ignoresSafeArea()
                .opacity(widgetViewModel.isLoading ? 0.4 : 0.0)
                .offset(y: widgetViewModel.isLoading ? 0.0 : UIScreen.screenHeight)
            
            LottieView(name: "loading2.json", play: $playLottie)
                .frame(width: 200, height: 200)
                .lottieLoopMode(.loop)
                .opacity(widgetViewModel.isLoading ? 1.0 : 0.0)
                .offset(y: widgetViewModel.isLoading ? 0 : UIScreen.screenHeight)
            
            
        }.alert(widgetViewModel.errorMessage, isPresented: $widgetViewModel.isErrorOccurred) {
            Button("ok") {
                widgetViewModel.isErrorOccurred = false
            }
        }
    }
    
    var bottomButtons : some View {
        VStack(spacing: 30) {
            
            Button {
                if widgetViewModel.historyWidgets.count > 1 && !getIsPro() {
                    withAnimation {
                        mainViewModel.BACKSTACK_PURCHASE = .UploadImageScreen
                        mainViewModel.SCREEN_VIEW = .Purchase
                    }
                } else {
                    widgetViewModel.uploadImageToHistory(image: widgetViewModel.selectedImage) { bool in
                        if bool {
                            widgetViewModel.isImageUplaoded = true
                            withAnimation {
                                mainViewModel.SCREEN_VIEW = .WidgetSingle
                            }
                        }
                    }
                }
            } label: {
                Image("btnSend")
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 40, height: 55)
            }
            
            
            Button {
                widgetViewModel.selectedImage = nil
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .WidgetSingle
                }
            } label: {
                Image("btnCancelBig")
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 40, height: 55)
            }
            
        }
    }
    
    var chosenImage : some View {
        VStack {
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                
                Image(uiImage: widgetViewModel.selectedImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width:UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
                
            }.clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                widgetViewModel.selectedImage = nil
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .WidgetSingle
                }
            } label: {
                Image("iconBack")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
            }
            
            Spacer()

            Text(appName)
                .bold()
                .font(.system(size: 16))
            
            Spacer()
            
            
            Image("img3Dots")
                .resizable()
                .frame(width: 24, height: 24)
                .padding()
                .opacity(0.0)

            
        }
    }
}

#Preview {
    UploadImageScreen()
}
