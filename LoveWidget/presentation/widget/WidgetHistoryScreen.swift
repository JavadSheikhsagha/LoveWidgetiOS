//
//  WidgetHistoryScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI
import LottieSwiftUI

struct WidgetHistoryScreen: View {
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var showBigView = false
    
    @State var playLottie = true
    
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
            
            Color.white
                .ignoresSafeArea()
                .opacity(widgetViewModel.isLoading ? 0.4 : 0.0)
                .offset(y: widgetViewModel.isLoading ? 0.0 : UIScreen.screenHeight)
            
            LottieView(name: "loading2.json", play: $playLottie)
                .frame(width: 200, height: 200)
                .lottieLoopMode(.loop)
                .opacity(widgetViewModel.isLoading ? 1.0 : 0.0)
                .offset(y: widgetViewModel.isLoading ? 0 : UIScreen.screenHeight)
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                    .opacity(showBigView ? 0.5 : 0.0)
                    .offset(y: showBigView ? 0.0 : UIScreen.screenHeight)
                    .onTapGesture {
                        withAnimation {
                            showBigView = false
                        }
                    }
                
                ZStack(alignment: .topTrailing) {
                    
                    
                    AsyncImage(url: URL(string: widgetViewModel.selectedImageForBigView ?? "https://img5.downloadha.com/hosein/files/2023/09/Starfield-pc-cover-large.jpg")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }.frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(y: showBigView ? 0.0 : UIScreen.screenHeight)
                        
                    
                }
                .offset(y: showBigView ? 0.0 : UIScreen.screenHeight)
                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                
            }
            
        }
    }
    
    var historyList : some View {
        ScrollView {
            
            VStack {
                
                if widgetViewModel.historyWidgets.count == 0 && !widgetViewModel.isLoading {
                    
                    Spacer()
                        .frame(height: UIScreen.screenWidth/2)
                    
                    Image(.emptyWidgetList)
                    
                    Spacer()
                        .frame(height: 16)
                    // body text
                    Text("You don’t have any history yet")
                      .font(Font.custom("SF UI Text", size: 16))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                    
                    Spacer()
                    
                } else {
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
                                    
                                }.onTapGesture {
                                    widgetViewModel.selectedImageForBigView = item.data
                                    withAnimation {
                                        showBigView = true
                                    }
                                }
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
            
            ZStack(alignment: .bottomTrailing) {
                
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
                
                ZStack {
                    
                    Color(hex: "#76767680")
                        .frame(width: 24, height: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    HStack(spacing: 2) {
                        
                        Text(String(historyItemModel.reaction))
                            .foregroundStyle(.white)
                            .font(.system(size: 10))
                        
                        Image(.iconHeartSmall)
                    }
                    
                }.padding(8)
                
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
            
            ZStack(alignment: .bottomTrailing) {
                
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
                
                ZStack {
                    
                    Color(hex: "#76767680")
                        .frame(width: 24, height: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    HStack(spacing: 2) {
                        
                        Text(String(historyItemModel.reaction))
                            .foregroundStyle(.white)
                            .font(.system(size: 10))
                        
                        Image(.iconHeartSmall)
                    }
                    
                }.padding(8)
                
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
