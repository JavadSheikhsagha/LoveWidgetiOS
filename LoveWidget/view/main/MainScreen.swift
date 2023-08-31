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
    
    @State var showFriendsBottomSheet = false
    @State var showEditNameDialog = false
    @State var showLogoutDialog = false
    @State var showDeleteAccountDialog = false
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
                    
                    AsyncImage(url: URL(string: loadUser()?.profileImage ?? "")!) { image in
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
                            
                            Text(loadUser()?.username ?? "Username")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Button {
                                // edit name dialog
                                withAnimation {
                                    showEditNameDialog.toggle()
                                }
                            } label: {
                                Image("imgEditNameIcon")
                            }

                            
                        }.padding()
                            .offset(y: 5)
                        
                    }.frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    ZStack {
                        Image("imgIdText")
                            .resizable()
                            .frame(width: UIScreen.screenWidth - 65, height: 67)
                        
                        HStack(alignment:.bottom) {
                            
                            Text(loadUser()?.code ?? "Code")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            Button {
                                UIPasteboard.general.setValue("TEXT TO COPY", // text
                                            forPasteboardType: UTType.plainText.identifier)
                            } label: {
                                Image("iconCopyToClipboard")
                            }

                            
                        }.padding()
                            .offset(y: 5)
                        
                    }.frame(width: UIScreen.screenWidth - 65, height: 67)
                    
                    Spacer()
                        .frame(height: 24)
                    
                    ShareLink(item: "TEXT TO SHARE") {
                        Image("imgShareMyCodeButton")
                            .resizable()
                            .frame(width: UIScreen.screenWidth - 65 ,height: 55)
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
                showFriendsBottomSheet = true
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
            if mainViewModel.widgets.count < 1 && mainViewModel.isLoading == false {
                
                Spacer()
                    .frame(height: 80)
                
                Image("emptyWidgetList")
                    
                
                Spacer()
                    .frame(height: 30)
                
                Text("Haven’t added any widget yet")
                    .bold()
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 60)
            } else {
                // LazyHStack for each widget
                
                
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
                    mainViewModel.changeUsername(newUsername: changeNameText) { bool in
                        if bool {
                            withAnimation {
                                showEditNameDialog = false
                            }
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
                        Image("btnLogout")
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
                                    showDeleteAccountDialog ?
                                    0.6 : 0.0)
                .ignoresSafeArea()
                .offset(y: showLogoutDialog ||
                        showEditNameDialog ||
                        showDeleteAccountDialog ?
                        0 : UIScreen.screenHeight)
                .onTapGesture {
                    withAnimation {
                        showLogoutDialog = false
                        showEditNameDialog = false
                        showDeleteAccountDialog = false
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
