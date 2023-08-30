//
//  WidgetSingleScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/29/23.
//

import SwiftUI

struct WidgetSingleScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
            
            
            VStack {
                
                header
                
                userImagesTop
                
                addHistoryCards
                
                checkHistoryCard
                
                addWidgetToHomeScreenBtn
                
                
            }
            
        }
    }
    
    var addWidgetToHomeScreenBtn : some View {
        VStack {
            
            Spacer()
            
            Button {
                
            } label: {
                Image(.addToHomeBtn)
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 48, height: 55)
            }

        }
    }
    
    var checkHistoryCard : some View {
        VStack {
            
            Spacer()
                .frame(height: 36)
            
            Button {
                
            } label: {
                Image(.checkHistoryCard)
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 40, height: 88)
            }

        }
    }
    
    var addHistoryCards : some View {
        VStack {
            
            Spacer().frame(height: 42)
            
            HStack(spacing: 24) {
                
                Button {
                    withAnimation {
                        mainViewModel.SCREEN_VIEW = .History
                    }
                } label: {
                    Image(.addQuoteCard)
                        .resizable()
                        .frame(width : (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
                }

                Button {
                    
                } label: {
                    Image(.addImageCard)
                        .resizable()
                        .frame(width : (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
                }
            }
        }
    }
    
    var userImagesTop : some View {
        VStack {
            
            HStack(spacing: 15) {
                
                VStack {
                    AsyncImage(url: URL(string: "imgUrl")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(.imgUserSample)
                                
                            }.frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                    
                    Text("Zeynab")
                      .font(Font.custom("SF UI Text", size: 14))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                }
                
                Button {
                    
                } label: {
                    Image(.imgHeartMiss)
                }.offset(y: -10)

                
                VStack(spacing: 20) {
                    
                    AsyncImage(url: URL(string: "imgUrl")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
//                                    Image(systemName: "photo.fill")
                                Image(.imgUserSample)
                            }.frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                    
                
                    
                    Text("Zeynab")
                      .font(Font.custom("SF UI Text", size: 14))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                }
            }
            
            
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
                .contextMenu {
                    Button("Delete Widget") {
                        // delete widget
                    }
                }

            
        }
    }
}

#Preview {
    WidgetSingleScreen()
}
