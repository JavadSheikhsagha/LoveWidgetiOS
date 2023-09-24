//
//  CreateWidgetScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI
import LottieSwiftUI

struct CreateWidgetScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var friendViewModel : FriendsViewModel
    
    @State var widgetName = ""
    @State var isButtonEnabled : Bool = false
    @State var showFriendsSheet = false
    @State var showIntroScreen = false
    @State var playLottie = true
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FEEAEA")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                widgetNameTextField
                
                userImagesTop
                
                createWidgetButton
                
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
            

        }
        .alert(widgetViewModel.errorMessage, isPresented: $widgetViewModel.isErrorOccurred) {
            Button("ok") {
                widgetViewModel.isErrorOccurred = false
            }
        }
        .sheet(isPresented: $showFriendsSheet) {
            FriendsScreen(doNeedSelectFriend: true)
        }
        .sheet(isPresented: $showIntroScreen) {
            IntroScreen()
        }
    }
    
    var createWidgetButton : some View {
        VStack {
            Spacer()
            
            FilledButton(text: "Save", isEnabled: $isButtonEnabled) {
                if isButtonEnabled {
                    isButtonEnabled = false
                    widgetViewModel.createWidget(name: widgetName, friendId: friendViewModel.selectedFriend?.id) { bool in
                        isButtonEnabled = true
                        if bool {
                            withAnimation {
                                mainViewModel.SCREEN_VIEW = .WidgetSingle
                            }
                            friendViewModel.selectedFriend = nil
                        } else {
                            
                        }
                    }
                }
                UIApplication.shared.endEditing()
            }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
            
            OutlineButton(text: "Discard") {
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .MainMenu
                }
            }.frame(width: UIScreen.main.bounds.width - 64, height: 55)

        }
    }
    
    var widgetNameTextField : some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                
                TextField("Widget name", text: $widgetName, prompt: Text("Widget name"))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    .onChange(of: widgetName) { newValue in
                        if widgetName.count > 0 {
                            isButtonEnabled = true
                        } else {
                            isButtonEnabled = false
                        }
                    }
                    
                    
            }.cornerRadius(10) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#FF8B8B"), lineWidth: 1)
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
                                Image(.addBtn)
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
                                    Image(.addBtn)
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
            
            Button {
                showIntroScreen = true
            } label: {
                Image(.iconInfo)
            }

            Spacer()
                .frame(width: 26)
            
            
        }
    }
}

#Preview {
    CreateWidgetScreen()
}
