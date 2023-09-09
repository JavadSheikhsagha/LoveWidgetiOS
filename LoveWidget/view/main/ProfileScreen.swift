//
//  ProfileScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/8/23.
//

import SwiftUI
import UniformTypeIdentifiers
import OneSignalFramework

struct ProfileScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @State var showFriendsBottomSheet = false
    @State var showEditNameDialog = false
    @State var showLogoutDialog = false
    @State var showDeleteAccountDialog = false
    @State var showAskForLoginDialog = false
    @State var changeNameText = ""
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                cardTopView
                
                Spacer()
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
                        UIApplication.shared.endEditing()
                    }
                
                logoutDialog
                
                deleteAccountDialog
                
                askForLoginDialog
                
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
            
            
            Menu {
                
            } label: {
                Image("img3Dots")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .opacity(0.0)
            }


            
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
                    if changeNameText.count > 0 {
                        mainViewModel.changeUsername(newUsername: changeNameText) { bool in
                            if bool {
                                withAnimation {
                                    showEditNameDialog = false
                                }
                            }
                        }
                    } else {
                        mainViewModel.isErrorOccurred = true
                        mainViewModel.errorMessage = "User must have at least 1 characters."
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
    
    
    var cardTopView : some View {
        VStack {
            
            ZStack {
                
                Color.white
                    .frame(width: UIScreen.screenWidth - 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        Menu {
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
                                        .foregroundStyle(.red)
                                }
                            }
                        } label: {
                            Image("img3Dots")
                                .padding()
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
                    
                    Text(loadUser()?.isVerified == true ? loadUser()?.code ?? "" : "")
                      .font(Font.custom("SF UI Text", size: 12))
                      .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                    
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
                            Image("imgEditTextName")
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65, height: 67)
                            
                            HStack(alignment:.bottom) {
                                
                                Text(loadUser()?.email ?? "")
                                    .font(.system(size: 16))
                                
                                Spacer()

                                
                            }.padding()
                                .offset(y: 5)
                            
                        }.frame(width: UIScreen.screenWidth - 65, height: 67)
                        
                        
                        ZStack {
                            Image("outlinePassword")
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65, height: 67)
                            
                            HStack(alignment:.bottom) {
                                
                                Text("*Password*")
                                    .font(.system(size: 16))
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        // change password
                                    }
                                } label: {
                                    Image("imgEditNameIcon")
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
                        ShareLink(item: "Hello. I am \(loadUser()?.username ?? "") and this is my code in love widget. \n\(loadUser()?.code ?? "") \nIf you don't have the love widget app yet, you can install it through the link below.\n $$LINK$$") {
                            Image("imgShareMyCodeButton")
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65 ,height: 55)
                        }
                    }

                }
                
            }
            .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth + 120)
            
        }
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
                        widgetViewModel.allWidgetsMain = []
                        widgetViewModel.historyWidgets = []
                        saveToken(token: "")
                        saveUser(userModel: nil)
                        saveAllWidgetsToDatabase(widgets: [])
                        OneSignal.logout()
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
    
}

#Preview {
    ProfileScreen()
}