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
    
    @State var showIntroScreen = false
    @State var showFriendsBottomSheet = false
    @State var showEditNameDialog = false
    @State var showEditPassDialog = false
    @State var showLogoutDialog = false
    @State var showDeleteAccountDialog = false
    @State var showAskForLoginDialog = false
    @State var showBanner = false
    @State var changeNameText = ""
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var newConfirmPassword = ""
    @State var bannerData = BannerData(title: "Fill all the fields.", detail: "", type: .error)
    @State var isConfirmPasswordOk = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                ScrollView(.vertical) {
                    VStack {
                        Spacer()
                            .frame(height: 24)
                        cardTopView
                            .frame(width: UIScreen.screenWidth - 40, height: 650)
                    }
                }
                
            }
            
            ZStack {
                
                Color.black.opacity(showLogoutDialog ||
                                    showEditNameDialog ||
                                    showEditPassDialog ||
                                    showAskForLoginDialog ||
                                    showDeleteAccountDialog ?
                                    0.6 : 0.0)
                .ignoresSafeArea()
                .offset(y: showLogoutDialog ||
                        showEditNameDialog ||
                        showEditPassDialog ||
                        showDeleteAccountDialog ||
                        showAskForLoginDialog ?
                        0 : UIScreen.screenHeight)
                .onTapGesture {
                    withAnimation {
                        showLogoutDialog = false
                        showEditNameDialog = false
                        showEditPassDialog = false
                        showDeleteAccountDialog = false
                        showAskForLoginDialog = false
                    }
                }
                
                changePassDialog
                
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
                
                Color.white
                    .ignoresSafeArea()
                    .opacity(mainViewModel.isLoading ? 0.4 : 0.0)
                    .offset(y: mainViewModel.isLoading ? 0.0 : UIScreen.screenHeight)
                    
                
            }
            
        }
        .sheet(isPresented: $showIntroScreen) {
            IntroScreen()
        }
        .banner(data: $bannerData, show: $showBanner)
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
                    .frame(width: 50, height: 50)
            }
            


            
        }.padding(.horizontal, 16)
    }
    
    
    var changeNameDialog : some View {
        ZStack {
            Color(hex: "#EEF1FF").clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                
                Spacer()
                    .frame(height: 8)
                
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
                                showBanner = true
                                bannerData = BannerData(title: "Name changed successfully", detail: "", type: .success)
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
        .frame(width: UIScreen.screenWidth - 40, height:  340)
        .opacity(showEditNameDialog ? 1.0 : 0.0)
        .offset(y: showEditNameDialog ? 0 : UIScreen.screenHeight)
    }
    
    var changePassDialog : some View {
        ZStack {
            
            Color(hex: "#EEF1FF").clipShape(RoundedRectangle(cornerRadius: 10))
                .onChange(of: oldPassword) { newValue in
                    isConfirmPasswordOk = (oldPassword.count > 5 &&
                                           newPassword.count > 5 &&
                                           newConfirmPassword == newPassword)

                    if newPassword != newConfirmPassword {
                        bannerData = BannerData(title: "new password must be equal to confirm new password",
                                                detail: "",
                                                type: .error)
                    }
                    if newPassword.count < 6 {
                        bannerData = BannerData(title: "new password must be at least 6 characters.",
                                                detail: "",
                                                type: .error)
                    }
                }
                .onChange(of: newPassword) { newValue in
                    isConfirmPasswordOk = (oldPassword.count > 5 &&
                                           newPassword.count > 5 &&
                                           newConfirmPassword == newPassword)
                    
                    if newPassword != newConfirmPassword {
                        bannerData = BannerData(title: "new password must be equal to confirm new password",
                                                detail: "",
                                                type: .error)
                    }
                    if newPassword.count < 6 {
                        bannerData = BannerData(title: "new password must be at least 6 characters.",
                                                detail: "",
                                                type: .error)
                    }
                }
                .onChange(of: newConfirmPassword) { newValue in
                    isConfirmPasswordOk = (oldPassword.count > 5 &&
                                           newPassword.count > 5 &&
                                           newConfirmPassword == newPassword)
                    
                    if newPassword != newConfirmPassword {
                        bannerData = BannerData(title: "new password must be equal to confirm new password",
                                                detail: "",
                                                type: .error)
                    }
                    
                    if newPassword.count < 6 {
                        bannerData = BannerData(title: "new password must be at least 6 characters.",
                                                detail: "",
                                                type: .error)
                    }
                }
            
            
            VStack {
                
                Spacer()
                    .frame(height: 28)
                
                Text("Edit Password")
                    .bold()
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 36)
                
                ZStack {
                    Image(.outlinePassword)
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    HStack(alignment:.bottom) {
                        
                        loginPasswordTextFieldView(text: $oldPassword,
                                                   title: "Password",
                                                   showTitle: false)
                        
                    }
                        .offset(y: 5)
                    
                }.frame(width: UIScreen.screenWidth - 65, height: 67)
                
                Spacer()
                    .frame(height: 20)
                
                ZStack {
                    Image(.outlineNewPassword)
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    HStack(alignment:.bottom) {
                        
                        loginPasswordTextFieldView(text: $newPassword,
                                                   title: "New Password",
                                                   showTitle: false)
                        
                    }
                        .offset(y: 5)
                    
                }.frame(width: UIScreen.screenWidth - 65, height: 67)
                
                
                ZStack {
                    Image(.outlineConfirmPassword)
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    HStack(alignment:.bottom) {
                        
                        loginPasswordTextFieldView(text: $newConfirmPassword,
                                                   title: "Confirm New Password",
                                                   showTitle: false)
                        
                    }
                        .offset(y: 5)
                    
                }.frame(width: UIScreen.screenWidth - 65, height: 67)
                
                
                Spacer()
                    .frame(height: 42)
                
                Button(action: {
                    //save name
                    if !loginViewModel.isLoading {
                        if isConfirmPasswordOk {
                            loginViewModel.changePasswordProfileScreen(password: newPassword,
                                                                       oldPassword: oldPassword)
                            { bool in
                                if bool {
                                    withAnimation {
                                        showEditPassDialog = false
                                    }
                                    showBanner = true
                                    bannerData = BannerData(title: "Password changed successfully", detail: "", type: .success)
                                } else {
                                    showBanner = true
                                    bannerData = BannerData(title: loginViewModel.errorMessage , detail: "", type: .error)
                                }
                            }
                        } else {
                            showBanner = true
                        }
                    }
                }, label: {
                    Image("btnSave")
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 64,height: 55)
                })
                    
                Button(action: {
                    //discard saving
                    withAnimation {
                        showEditPassDialog = false
                    }
                }, label: {
                    Image("btnDiscard")
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 64,height: 55)
                })
                
                Spacer()
                    .frame(height: 16)
                
            }
            
        }
        .frame(width: UIScreen.screenWidth - 40, height:  500)
        .opacity(showEditPassDialog ? 1.0 : 0.0)
        .offset(y: showEditPassDialog ? 0 : UIScreen.screenHeight)
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
                
                VStack(spacing: 16) {
                    
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
                            Image(.outlineEmail)
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
                            Image(.outlinePasswordFilled)
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 65, height: 67)
                            
                            HStack(alignment:.bottom) {
                                
                                
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        showEditPassDialog = true
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
                    
                    Button {
                        withAnimation {
                            mainViewModel.BACKSTACK_PURCHASE = .Profile
                            mainViewModel.SCREEN_VIEW = .Purchase
                        }
                    } label: {
                        ZStack {
                            
                            Color(hex: "#FF8B8B")
                                .frame(width: UIScreen.screenWidth - 64, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            HStack {
                                
                                Text("Premium")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Image(.iconPremium)
                                
                            }
                        }
                    }
                    
                    HStack {
                        
                        Spacer()
                            .frame(width: 36)
                        
                        Image(.imgPremiumClick)
                        
                        Spacer()
                        
                    }

                    
                    Spacer()
                }
                
            }
            .frame(width: UIScreen.screenWidth - 40, height: 650)
            
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
