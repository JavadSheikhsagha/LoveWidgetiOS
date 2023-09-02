//
//  DonePhotoWidgetScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/2/23.
//

import SwiftUI

struct DonePhotoWidgetScreen: View {
    
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
            
            VStack {
                
                header
                
                chosenImage
                
                bottomButtons
                
            }
            
        }
    }
    
    var bottomButtons : some View {
        VStack(spacing: 30) {
            
            Button {
                
            } label: {
                Image("btnSend")
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 40, height: 55)
            }
            
            
            Button {
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
                
                Image(uiImage: widgetViewModel.selectedImage!)
                    .resizable()
                    .frame(width:UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
                
            }.clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
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
                .contextMenu {
                    Button("Delete Widget") {
                        
                    }
                }

            
        }
    }
}

#Preview {
    DonePhotoWidgetScreen()
}
