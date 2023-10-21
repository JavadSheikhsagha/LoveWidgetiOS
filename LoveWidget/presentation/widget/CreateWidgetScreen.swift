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
                
                selectedFriendsList
                
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
    
    var selectedFriendsList : some View {
        
        VStack {
            
            ScrollView {
                VStack {
                    
                    ForEach(friendViewModel.selectedFriends, id: \.id) { friend in
                        
                        Spacer()
                            .frame(height: 28)
                        
                        ZStack {
                            
                            Color(hex: "#FFE5E5")
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            HStack(spacing: 14) {
                                
                                
                                AsyncImage(url: URL(string: friend.profileImage)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Image(.imgUserSample)
                                                .resizable()
                                                .frame(width: 52, height: 52)
                                        }.frame(width: 52, height: 52)
                                    .clipShape(RoundedRectangle(cornerRadius: 42))
                                
                                
                                Text(friend.username)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                                
                                Spacer()
                                
                                Menu {
                                    Button("Remove") {
                                        friendViewModel.selectedFriends = friendViewModel.selectedFriends.filter({ item in
                                            return item.id != friend.id
                                        })
                                    }
                                } label: {
                                    Image(.img3Dots)
                                }
                                
                            }.padding()
                            
                        }.frame(width: UIScreen.screenWidth - 40, height: 72)
                            .onAppear(perform: {
                                print("here is tyour friend")
                            })
                    }
                    
                }
            }
        }
    }
    
    var createWidgetButton : some View {
        VStack {
            
            FilledButton(text: "Save", isEnabled: $isButtonEnabled) {
                if isButtonEnabled {
                    isButtonEnabled = false
                    
                    //create widget
                    widgetViewModel.createWidgetWithMultipleFriends(widgetName: widgetName, friends: friendViewModel.selectedFriends) { bool in
                        if bool {
                            withAnimation {
                                mainViewModel.SCREEN_VIEW = .WidgetSingle
                            }
                            friendViewModel.selectedFriends = []
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
                        
                        Image(.addBtn)
                            .resizable()
                            .frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                        
                        Text("Add Friend")
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
