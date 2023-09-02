//
//  CreateWidgetScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI

struct CreateWidgetScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var friendViewModel : FriendsViewModel
    
    @State var widgetName = ""
    @State var isButtonEnabled : Bool = false
    @State var showFriendsSheet = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
            
            VStack {
                header
                
                widgetNameTextField
                
                userImagesTop
                
                createWidgetButton
            }
        }
        .alert(widgetViewModel.errorMessage, isPresented: $widgetViewModel.isErrorOccurred) {
            Button("ok") {
                widgetViewModel.isErrorOccurred = false
            }
        }
        .sheet(isPresented: $showFriendsSheet) {
            FriendsScreen(doNeedSelectFriend: true)
        }
    }
    
    var createWidgetButton : some View {
        VStack {
            Spacer()
            
            Button {
                // create widget in server
                if isButtonEnabled {
                    widgetViewModel.createWidget(name: widgetName, friendId: friendViewModel.selectedFriend?.id) { bool in
                        if bool {
                            withAnimation {
                                mainViewModel.SCREEN_VIEW = .WidgetSingle
                            }
                        } else {
                            
                        }
                    }
                }
                
            } label: {
                ZStack {
                    
                    Color(hex:  isButtonEnabled ? "#6D8DF7" : "#C7C7C7")
                    
                    Text("Save")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    
                }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
//            Button {
//                // show tutorial
//                
//            } label: {
//                Image(.addToHomeBtn)
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width - 64, height: 55)
//            }

        }
    }
    
    var widgetNameTextField : some View {
        VStack {
            Spacer()
                .frame(height: 80)
            
            ZStack {
                
                TextField("Widget name", text: $widgetName, prompt: Text("Widget name"))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    .onChange(of: widgetName) { newValue in
                        if widgetName.count > 3 {
                            isButtonEnabled = true
                        } else {
                            isButtonEnabled = false
                        }
                    }
                    
                    
            }.cornerRadius(10) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
            )
            
            Spacer()
                .frame(height: 54)
        }
    }
    
    var userImagesTop : some View {
        VStack {
            
            HStack(spacing: 15) {
                
                VStack {
                    AsyncImage(url: URL(string: loadUser()?.profileImage ?? "imageUrl")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(.imgUserSample)
                                    .resizable()
                            }.frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                    
                    Text(loadUser()?.username ?? "Username")
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                      .font(Font.custom("SF UI Text", size: 14))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                }
                
                Image(.imgHeartMiss)
                    .offset(y: -10)

                
                Button {
                    // open friends bottom sheet
                    showFriendsSheet = true
                } label: {
                    VStack(spacing: 20) {
                        
                        AsyncImage(url: URL(string: friendViewModel.selectedFriend?.profileImage ?? "imageUrl")!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
//                                    Image(systemName: "photo.fill")
                                    Image(.imgUserSample)
                                        .resizable()
                                }.frame(width: 84, height: 84)
                            .clipShape(RoundedRectangle(cornerRadius: 42))
                        
                    
                        
                        Text(friendViewModel.selectedFriend?.username ?? "Add Friend")
                            .multilineTextAlignment(.center)
                            .frame(width: 100)
                          .font(Font.custom("SF UI Text", size: 14))
                          .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                        
                    }
                }
                
            }
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .MainMenu
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
    CreateWidgetScreen()
}
