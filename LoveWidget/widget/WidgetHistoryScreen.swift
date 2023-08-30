//
//  WidgetHistoryScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI

struct WidgetHistoryScreen: View {
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
            
            VStack {
                
                header
                
                friendsList
                
                
            }
            
        }
    }
    
    var friendsList : some View {
        ScrollView {
            
            VStack {
                
                ForEach(widgetViewModel.historyWidgets, id: \.self) { widget in
                    
                    HStack {
                        VStack {
                            
                            Image(.imgUserSample)
                                .resizable()
                                .frame(width: 36, height: 36)
                            
                            Spacer()
                            
                        }
                        
                        Spacer()
                            .frame(width: 30)
                        
                        ZStack {
                            
                            Image(.addImageCard)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }.frame(width: 165, height: 165)
                        
                        Spacer()
                    }
                    
                }
                
                
            }
            .padding(.horizontal, 20)
        }
    }
    
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                
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
    WidgetHistoryScreen()
}
