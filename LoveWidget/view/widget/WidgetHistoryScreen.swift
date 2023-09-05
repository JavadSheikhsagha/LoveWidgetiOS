//
//  WidgetHistoryScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI

struct WidgetHistoryScreen: View {
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onAppear {
                    widgetViewModel.getHistoryList { Bool in
                        
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                historyList
                
                
            }
            
        }
    }
    
    var historyList : some View {
        ScrollView {
            
            VStack {
                
                ForEach(widgetViewModel.historyWidgets, id: \.showTime) { widget in
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Text(widget.showTime)
                          .font(Font.custom("SF UI  Text", size: 14))
                          .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                        
                        Spacer()
                            .frame(height: 20)
                        
                        ForEach(widget.data, id:\.id) { item in
                            
                            VStack {
                                
                                if item.sender.username == loadUser()?.username {
                                    SenderIsUser(historyItemModel: item)
                                } else {
                                    SenderIsGuest(historyItemModel: item)
                                }
                                
                                Spacer()
                                    .frame(height: 16)
                                
                            }
                        }
                        
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

struct SenderIsGuest : View {
    
    let historyItemModel : HistoryItemModel
    
    var body: some View {
        HStack {
            VStack {
                
//                Image(.imgUserSample)
//                    .resizable()
//                    .frame(width: 36, height: 36)
                
                AsyncImage(url: URL(string: historyItemModel.sender.profileImage)!) { image in
                            image
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        } placeholder: {
                            Image(.imgUserSample)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
//                            Image(systemName: "photo.fill")
                        }.frame(width: 36, height: 36)
                
                Spacer()
                
            }
            
            Spacer()
                .frame(width: 30)
            
            ZStack {
                
                AsyncImage(url: URL(string: historyItemModel.data)!) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 165, height: 165)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            Image(.imgUserSample)
//                            Image(systemName: "photo.fill")
                        }
                
            }.frame(width: 165, height: 165)
            
            Spacer()
                .frame(width: 14)
            
            Text(historyItemModel.createdAt)
              .font(Font.custom("SF UI  Text", size: 12))
              .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            
            Spacer()
        }
    }
}

struct SenderIsUser : View {
    
    let historyItemModel : HistoryItemModel
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Text(historyItemModel.createdAt)
              .font(Font.custom("SF UI  Text", size: 12))
              .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
            
            
            Spacer()
                .frame(width: 14)
            
            ZStack {
                
//                Image(.addImageCard)
//                    .resizable()
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                AsyncImage(url: URL(string: historyItemModel.data)!) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 165, height: 165)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            Image(.imgUserSample)
                                .resizable()
//                            Image(systemName: "photo.fill")
                        }
                
            }.frame(width: 165, height: 165)
            
            Spacer()
                .frame(width: 30)
            
            VStack {
                
                AsyncImage(url: URL(string: historyItemModel.sender.profileImage)!) { image in
                    image
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        } placeholder: {
                            Image(.imgUserSample)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
//                            Image(systemName: "photo.fill")
                        }.frame(width: 36, height: 36)
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    WidgetHistoryScreen()
}
