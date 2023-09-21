//
//  MainScreen.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import UniformTypeIdentifiers
import WidgetKit
import OneSignalFramework

var appName = "Love Widget"

struct MainScreen: View {
    
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var friednsViewModel : FriendsViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var showFriendsBottomSheet = false
    @State var isButtonEnabled = true
    @State var showAskForLoginDialog = false
    @State var changeNameText = ""
    @State var showBanner = false
    @State var showIntroScreen = false
    @State var showBigView = false
    @State var bannerData = BannerData(title: "Copied to clipboard.", detail: "", type: .success)
    
    
    var cardTopView : some View {
        VStack {
            
            
            HStack {
                
                AsyncImage(url: URL(string: loadUser()?.profileImage ?? "https://img5.downloadha.com/hosein/files/2023/09/Starfield-pc-cover-large.jpg")!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "photo.fill")
                        }.frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 42))
                    .onTapGesture {
                        withAnimation {
                            mainViewModel.SCREEN_VIEW = .Profile
                        }
                    }
                
                Spacer()
                
                Text(appName)
                    .bold()
                    .font(.system(size: 16))
                    .offset(y: -10)
                
                Spacer()
                
                Button {
                    showIntroScreen = true
                } label: {
                    Image(.iconInfo)
                        .frame(width: 50, height: 50)
                }
                
                
            }.padding(.horizontal, 16)
            
            Spacer()
                .frame(height: 48)
            
            ZStack {
                
                Color.white
                    .frame(width: UIScreen.screenWidth - 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                
                VStack {
                    
                    if isUserGuest() {
                        
                        VStack {
                            Spacer()
                            
                            Text("For using all features please login first")
                            .font(Font.custom("SF UI Text", size: 16))
                            .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))

                            
                        }.frame(width: UIScreen.screenWidth - 65, height: 67)
                        
                    } else {
                        ZStack {
                            Image("imgIdText")
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65, height: 67)
                            
                            HStack(alignment:.bottom) {
                                
                                Text(loadUser()?.code ?? "Code")
                                    .font(.system(size: 16))
                                
                                Spacer()
                                
                                Button {
                                    UIPasteboard.general.setValue(loadUser()?.code ?? "", // text
                                                forPasteboardType: UTType.plainText.identifier)
                                    showBanner = true
                                } label: {
                                    Image("iconCopyToClipboard")
                                }

                                
                            }.padding()
                                .offset(y: 5)
                            
                        }.frame(width: UIScreen.screenWidth - 65, height: 67)
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                    if isUserGuest() {
                        FilledButton(text: "Login", isEnabled: $isButtonEnabled) {
                            withAnimation {
                                showAskForLoginDialog = true
                            }
                        }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    } else {
                        ShareLink(item: "Hey there! I just came across this awesome app that lets us connect and make each other's day a little brighter :)\n\nThis is my code inside this program: \(loadUser()?.code ?? "")\n\nYou can simply download it by clicking on the link provided below.\n\n https://apps.apple.com/us/app/widgetapp-for-ios-17/id6463491116") {
                            ZStack {
                                Color(hex:"#6D8DF7")
                                
                                HStack {
                                    Text("Share my code")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.white)
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 10))
                        }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    }

                }
                
                
            }
            .frame(width: UIScreen.screenWidth - 40, height: 200)
            
        }
    }
    
    var inviteFiendsView : some View {
        VStack {
            
            Spacer()
                .frame(height: 28)
            
            FilledButton(text: "friends",colorBackground: "#FF8B8B", isEnabled: $isButtonEnabled) {
                if isUserGuest() {
                    withAnimation {
                        showAskForLoginDialog = true
                    }
                } else {
                    showFriendsBottomSheet = true
                }
            }.frame(width: UIScreen.screenWidth - 44, height: 55)
            
            HStack {
                
                Spacer()
                    .frame(width: 48)
                
                Image("inviteFriendsText")
                
                Spacer()
                
            }
            
        }
    }
    
    var widgetListView : some View {
        VStack {
            if widgetViewModel.allWidgetsMain.count < 1 && widgetViewModel.isLoading == false {
                
                Spacer()
                    .frame(height: 80)
                
                Image("emptyWidgetList")
                    
                
                Spacer()
                    .frame(height: 30)
                
                Text("Haven’t added any widget yet")
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 60)
            } else {
                // LazyHStack for each widget
                
                Spacer()
                    .frame(height: 20)
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: 20)
                        
                        LazyVGrid(columns: [
                            GridItem(),
                            GridItem(),
                        ]) {
                            
                            ForEach(widgetViewModel.allWidgetsMain, id: \.id) { widget in
                                
                                VStack {
                                    WidgetListSingleView(widget: widget)
                                        .onTapGesture {
                                            widgetViewModel.selectedWidgetModel = widget
                                            withAnimation {
                                                mainViewModel.SCREEN_VIEW = .WidgetSingle
                                            }
                                        }
                                        .onLongPressGesture(perform: {
                                            widgetViewModel.selectedImageForBigView = widget.contents?.data
                                            withAnimation {
                                                showBigView = true
                                            }
                                        })
                                        .frame(width:UIScreen.screenWidth - 64/2)
                                
                                    Spacer()
                                        .frame(height: 40)
                                }
                            }
                        
                            
                        }
                        
                        Spacer()
                            .frame(height: 40)

                    }
                    
                }
                
            }
        }
    }
    
    var btnAddNewWidget : some View {
        VStack {
            Button(action: {
                if loadUser()?.isVerified == false {
                    withAnimation {
                        showAskForLoginDialog = true
                    }
                } else {
                    withAnimation {
                        mainViewModel.SCREEN_VIEW = .CreateWidget
                    }
                }
            }, label: {
                Image("btnAddNewWidget")
            })
            
        }
    }
        
    var askForLoginDialog : some View {
        ZStack {
            
            Color(hex: "#FFFFFF")
                .frame(width: UIScreen.screenWidth - 64, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 20) {
                
                HStack {
                    Text("Please login first")
                    
                }.padding(.horizontal, 24)
                
                Text("For using this app, please log in first")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#707070"))
                
                
                HStack(spacing: 32) {
                    
                    Button(action: {
                        withAnimation {
                            showAskForLoginDialog = false
                        }
                    }, label: {
                        Image("btnCancel")
                    })
                    
                    Button(action: {
                        withAnimation {
                            showAskForLoginDialog = false
                            mainViewModel.SCREEN_VIEW = .Login
                        }
                    }, label: {
                        Image("btnLoginSmall")
                    })
                    
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 64, height: 180)
        .opacity(showAskForLoginDialog ? 1.0 : 0.0)
        .offset(y: showAskForLoginDialog ? 0 : UIScreen.screenHeight)
    }
    
     
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onAppear {
                    friednsViewModel.getFriends { bool in }
                    widgetViewModel.getWidgets { bool in }
                    friednsViewModel.selectedFriend = nil
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
//                .onReceive(timer) { time in
//                    friednsViewModel.getFriends { bool in }
//                    widgetViewModel.getWidgets { bool in }
//                    friednsViewModel.selectedFriend = nil
//                }
            
            VStack {
                ScrollView(showsIndicators: false) {
                    
                    Spacer()
                        .frame(height: 12)
                    
                    cardTopView
                    
                    inviteFiendsView
                    
                    widgetListView
                    
                    Spacer()
                        .frame(height: 48)
                    
                }.refreshable {
                    widgetViewModel.getWidgets { bool in
                        
                    }
                    friednsViewModel.getFriends { Bool in
                        
                    }
                }
                
                
            }
            
            VStack {
                Spacer()
                ZStack {
                    
                    Color.white
                        .opacity(0.9)
                        .ignoresSafeArea()
                        .frame(width: UIScreen.screenWidth, height: 80)
                        .blur(radius: 3.0)
                    
                    btnAddNewWidget
                }
            }
            
            ZStack {
                
                Color.black.opacity(showAskForLoginDialog ?
                                    0.6 : 0.0)
                .ignoresSafeArea()
                .offset(y: showAskForLoginDialog ?
                        0 : UIScreen.screenHeight)
                .onTapGesture {
                    withAnimation {
                        showAskForLoginDialog = false
                    }
                }
                
                
                askForLoginDialog
                
            }
            
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
                        
                    
                }
                .offset(y: showBigView ? 0.0 : UIScreen.screenHeight)
                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                
            }
            
        }
        .banner(data: $bannerData, show: $showBanner)
        .sheet(isPresented: $showFriendsBottomSheet) {
            FriendsScreen()
        }
        .alert(mainViewModel.errorMessage, isPresented: $mainViewModel.isErrorOccurred) {
            Button("ok") {
                mainViewModel.isErrorOccurred = false
            }
        }
        .sheet(isPresented: $showIntroScreen) {
            IntroScreen()
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

extension UIScreen {
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    static var screenHeight : CGFloat {
        UIScreen.main.bounds.height
    }
    
}


struct WidgetListSingleView : View {
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var widget : WidgetServerModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                
                if widget.contents != nil {
                    ZStack(alignment: .bottomTrailing) {
                        if let imageUrl = widget.contents!.data {
                            AsyncImage(url: URL(string: imageUrl)!) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
                                    } placeholder: {
                                        Image(.imgUserSample)
                                    }
                            
                            Button {
                                widgetViewModel.reactToContent(
                                    contentId: widget.contents?.id ?? "",
                                    widgetId: widget.id ?? "")
                                { bool in
                                    
                                    let wid = loadWidget(by: widget.id ?? "")
                                    widget.contents?.reaction = wid?.contents?.reaction
                                    print(wid?.contents?.reaction ?? 100)
                                    
                                }
                            } label: {
                                VStack {
                                    if widget.contents?.reaction ?? 0 > 0 {
                                        Image(.imgLikeFilled)
                                    } else {
                                        Image(.imgLikeBorder)
                                    }
                                }.padding(10)
                            }
                             
                        } else {
                            Image("emptyWidgetImage")
                                .resizable()
                        }
                        
                    }
                } else {
                    Image("emptyWidgetImage")
                        .resizable()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
            
            Spacer()
                .frame(height: 5)
            
            Text("Me \(widget.member != "" ? "& \(widget.member!)" : "")")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: "#767676"))
            
            Spacer()
                .frame(height: 7)
            
            Text(widget.name ?? "widget")
              .font(Font.custom("SF UI  Text", size: 14))
              .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
            
        }
        .frame(width: (UIScreen.screenWidth - 64) / 2, height: ((UIScreen.screenWidth - 64) / 2) + 20)
    }
    
}
