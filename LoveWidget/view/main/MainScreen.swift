//
//  MainScreen.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import UniformTypeIdentifiers

var appName = "Love Widget"

struct MainScreen: View {
    
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var friednsViewModel : FriendsViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var showFriendsBottomSheet = false
    @State var showEditNameDialog = false
    @State var showLogoutDialog = false
    @State var showDeleteAccountDialog = false
    @State var showAskForLoginDialog = false
    @State var changeNameText = ""
    
    
    var cardTopView : some View {
        VStack {
            
            
            Text(appName)
                .bold()
                .font(.system(size: 16))
            
            ZStack {
                
                Color.white
                    .frame(width: UIScreen.screenWidth - 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image("img3Dots")
                            .padding()
                            .contextMenu {
                                Button {
                                    withAnimation {
                                        showLogoutDialog = true
                                    }
                                } label: {
                                    Text("Logout")
                                }
                                
                                if !isUserGuest() {
                                    Button {
                                        withAnimation {
                                            showDeleteAccountDialog = true
                                        }
                                    } label: {
                                        Text("Delete Account")
                                    }
                                }
                                
                            }
                        
                    }
                    
                    Spacer()
                }
                
                VStack {
                    
                    Spacer()
                        .frame(height: 24)
                    
                    AsyncImage(url: URL(string: loadUser()?.profileImage ?? "https://img5.downloadha.com/hosein/files/2023/09/Starfield-pc-cover-large.jpg")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }.frame(width: 84, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 42))
                    
                    ZStack {
                        Image("imgEditTextName")
                            .resizable()
                            .frame(width: UIScreen.screenWidth - 65, height: 67)
                        
                        HStack(alignment:.bottom) {
                            
                            Text(isUserGuest() ? "Guest" : loadUser()?.username ?? "Username")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Button {
                                // edit name dialog
                                if !isUserGuest() {
                                    withAnimation {
                                        showEditNameDialog.toggle()
                                    }
                                }
                            } label: {
                                if isUserGuest() {
                                    Image("imgEditNameIcon")
                                        .opacity(0.2)
                                } else {
                                    Image("imgEditNameIcon")
                                }
                                    
                            }

                            
                        }.padding()
                            .offset(y: 5)
                        
                    }.frame(width: UIScreen.screenWidth - 65, height: 67)
                    
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
                        Button {
                            withAnimation {
                                showAskForLoginDialog = true
                            }
                            
                        } label: {
                            ZStack {
                                
                                Color(hex:"#6D8DF7")
                                
                                Text("Login")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                
                            }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    } else {
                        ShareLink(item: loadUser()?.code ?? "") {
                            Image("imgShareMyCodeButton")
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65 ,height: 55)
                        }
                    }

                }
                
                
            }
            .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth)
            
        }
    }
    
    var inviteFiendsView : some View {
        VStack {
            
            Spacer()
                .frame(height: 28)
            
            Button(action: {
                if isUserGuest() {
                    withAnimation {
                        showAskForLoginDialog = true
                    }
                } else {
                    showFriendsBottomSheet = true
                }
            }, label: {
                Image("imgInviteFriends")
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 44, height: 55)
            })
            
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
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        ForEach(widgetViewModel.allWidgetsMain, id: \.id) { widget in
                            
                            WidgetListSingleView(widget: widget)
                                .onTapGesture {
                                    widgetViewModel.selectedWidgetModel = widget
                                    withAnimation {
                                        mainViewModel.SCREEN_VIEW = .WidgetSingle
                                    }
                                }
                            
                            Spacer()
                                .frame(height: 40)
                        }
                    }
                    
                }.padding(.horizontal, 20)
                
            }
        }
    }
    
    var btnAddNewWidget : some View {
        VStack {
            Button(action: {
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .CreateWidget
                }
            }, label: {
                Image("btnAddNewWidget")
            })
            
        }
    }
    
    var changeNameDialog : some View {
        ZStack {
            Color(hex: "#EEF1FF").clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                
                Spacer()
                    .frame(height: 28)
                
                Text("Edit Name")
                    .bold()
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 36)
                
                ZStack {
                    Image("imgEditTextName")
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    HStack(alignment:.bottom) {
                        
                        TextField("Username", text: $changeNameText)
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Image("imgEditNameIcon")

                        
                    }.padding()
                        .offset(y: 5)
                    
                }.frame(width: UIScreen.screenWidth - 65, height: 67)
                
                Spacer()
                    .frame(height: 42)
                
                Button(action: {
                    //save name
                    if changeNameText.count > 4 {
                        mainViewModel.changeUsername(newUsername: changeNameText) { bool in
                            if bool {
                                withAnimation {
                                    showEditNameDialog = false
                                }
                            }
                        }
                    } else {
                        mainViewModel.isErrorOccurred = true
                        mainViewModel.errorMessage = "User must have at least 4 characters."
                    }
                }, label: {
                    Image("btnSave")
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 64,height: 55)
                })
                    
                Button(action: {
                    //discard saving
                    withAnimation {
                        showEditNameDialog = false
                    }
                }, label: {
                    Image("btnDiscard")
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 64,height: 55)
                })
            }
            
        }
        .frame(width: UIScreen.screenWidth - 40, height:  UIScreen.screenWidth)
        .opacity(showEditNameDialog ? 1.0 : 0.0)
        .offset(y: showEditNameDialog ? 0 : UIScreen.screenHeight)
    }
    
    var logoutDialog : some View {
        ZStack {
            
            Color(hex: "#FFFFFF")
                .frame(width: UIScreen.screenWidth - 64, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 20) {
                
                Text("Are you sure you want to logout?")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#707070"))
                
                
                HStack(spacing: 32) {
                    
                    Button(action: {
                        withAnimation {
                            showLogoutDialog = false
                        }
                    }, label: {
                        Image("btnCancel")
                    })
                    
                    Button(action: {
                        saveToken(token: "")
                        saveUser(userModel: nil)
                        withAnimation {
                            showLogoutDialog = false
                            mainViewModel.SCREEN_VIEW = .Login
                        }
                    }, label: {
                        Image("btnLogout")
                    })
                    
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 64, height: 120)
        .opacity(showLogoutDialog ? 1.0 : 0.0)
        .offset(y: showLogoutDialog ? 0 : UIScreen.screenHeight)
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
    
    
    var deleteAccountDialog : some View {
        ZStack {
            
            Color(hex: "#FFFFFF")
                .frame(width: UIScreen.screenWidth - 64, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 20) {
                
                Text("Are you sure you want to delete your account?")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#707070"))
                
                
                HStack(spacing: 32) {
                    
                    Button(action: {
                        withAnimation {
                            showDeleteAccountDialog = false
                        }
                    }, label: {
                        Image("btnCancel")
                    })
                    
                    Button(action: {
                        mainViewModel.deleteUser { bool in
                            if bool {
                                withAnimation {
                                    showDeleteAccountDialog = false
                                    mainViewModel.SCREEN_VIEW = .Login
                                }
                            }
                        }
                    }, label: {
                        Image("btnDelete")
                    })
                    
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 64, height: 120)
        .opacity(showDeleteAccountDialog ? 1.0 : 0.0)
        .offset(y: showDeleteAccountDialog ? 0 : UIScreen.screenHeight)
    }
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onAppear {
                    friednsViewModel.getFriends { bool in }
                    widgetViewModel.getWidgets { bool in }
                }
            
            VStack {
                ScrollView(showsIndicators: false) {
                    
                    Spacer()
                        .frame(height: 0)
                    
                    cardTopView
                    
                    inviteFiendsView
                    
                    widgetListView
                    
                    Spacer()
                        .frame(height: 48)
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
                
                Color.black.opacity(showLogoutDialog ||
                                    showEditNameDialog ||
                                    showAskForLoginDialog ||
                                    showDeleteAccountDialog ?
                                    0.6 : 0.0)
                .ignoresSafeArea()
                .offset(y: showLogoutDialog ||
                        showEditNameDialog ||
                        showDeleteAccountDialog ||
                        showAskForLoginDialog ?
                        0 : UIScreen.screenHeight)
                .onTapGesture {
                    withAnimation {
                        showLogoutDialog = false
                        showEditNameDialog = false
                        showDeleteAccountDialog = false
                        showAskForLoginDialog = false
                    }
                }
                
                
                changeNameDialog
                    .onChange(of: showEditNameDialog) { newValue in
                        if newValue {
                            changeNameText = loadUser()?.username ?? ""
                        }
                    }
                
                logoutDialog
                
                deleteAccountDialog
                
                askForLoginDialog
                
            }
            
        }
        .sheet(isPresented: $showFriendsBottomSheet) {
            FriendsScreen()
        }
        .alert(mainViewModel.errorMessage, isPresented: $mainViewModel.isErrorOccurred) {
            Button("ok") {
                mainViewModel.isErrorOccurred = false
            }
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
    
    @State var widget : WidgetServerModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                
                if widget.contents?.count ?? 0 > 0 {
                    AsyncImage(url: URL(string: widget.contents![0].data)!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                } else {
                    Image("emptyWidgetImage")
                        .resizable()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: (UIScreen.screenWidth - 64) / 2, height: (UIScreen.screenWidth - 64) / 2)
            
            
            
            Text(widget.name ?? "widget")
              .font(Font.custom("SF UI  Text", size: 14))
              .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
            
        }
        .frame(width: (UIScreen.screenWidth - 64) / 2, height: ((UIScreen.screenWidth - 64) / 2) + 20)
    }
    
}
