//
//  FriendsScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI
import SwiftyStoreKit
import EnigmaSystemDesign
import LottieSwiftUI

struct FriendsScreen: View {
    
    @EnvironmentObject var friednsViewModel : FriendsViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var showAddFriendDialog = false
    @State var showRemoveFriendDialog = false
    @State var selectedFriendToRemove : UserModel? = nil
    @State var friendCode = ""
    @State var playLottie = true
    
    var doNeedSelectFriend = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FFF8F8")
                .ignoresSafeArea()
                .onAppear {
                    if !isUserGuest() {
                        friednsViewModel.getFriends { bool in }
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            friendsListView
                .onChange(of: showAddFriendDialog) { newValue in
                    if newValue {
                        friendCode = ""
                    }
                }
            
            addFriendDialog
                .onChange(of: showAddFriendDialog) { neVa in
                    UIApplication.shared.endEditing()
                }
            
            ZStack {
                Color.black.opacity(showRemoveFriendDialog ? 0.5 : 0.0)
                    .ignoresSafeArea()
                    .offset(y: showRemoveFriendDialog ? 0 : UIScreen.screenHeight)
                    .onTapGesture {
                        withAnimation {
                            showRemoveFriendDialog = false
                        }
                    }
                
                removeFriendDialog
            }
            
            Color.white
                .ignoresSafeArea()
                .opacity(friednsViewModel.isLoading ? 0.4 : 0.0)
                .offset(y: friednsViewModel.isLoading ? 0.0 : UIScreen.screenHeight)
            
            LottieView(name: "loading2.json", play: $playLottie)
                .frame(width: 200, height: 200)
                .lottieLoopMode(.loop)
                .opacity(friednsViewModel.isLoading ? 1.0 : 0.0)
                .offset(y: friednsViewModel.isLoading ? 0 : UIScreen.screenHeight)
            
        }
        .alert(friednsViewModel.errorMessage, isPresented: $friednsViewModel.isErrorOccurred) {
            Button("ok") {
                friednsViewModel.isErrorOccurred = false
            }
        }
    }
    
    var removeFriendDialog : some View {
        ZStack {
            
            Color(hex: "#F9FBFD")
                .frame(width: UIScreen.screenWidth - 64, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 20) {
                
                Text("Are you sure you want to remove your friend?")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#707070"))
                
                
                HStack(spacing: 32) {
                    
                    Button(action: {
                        withAnimation {
                            showRemoveFriendDialog = false
                        }
                    }, label: {
                        Image("btnCancel")
                    })
                    
                    Button(action: {
                        
                        friednsViewModel.deleteFriend(friendId: selectedFriendToRemove?.id ?? "") { bool in
                            if bool {
                                withAnimation {
                                    showRemoveFriendDialog = false
                                }
                            } else {
                                
                            }
                        }
                        
                    }, label: {
                        Image(.btnRemove)
                    })
                    
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 64, height: 120)
        .opacity(showRemoveFriendDialog ? 1.0 : 0.0)
        .offset(y: showRemoveFriendDialog ? 0 : UIScreen.screenHeight)
    }
    
    var addFriendDialog : some View {
        ZStack {
            
            Color.black
                .opacity(showAddFriendDialog ? 0.5 : 0.0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showAddFriendDialog = false
                    }
                }
            
            ZStack {
                
                Color(hex: "#F9FBFD")
                    .frame(width: UIScreen.screenWidth - 40, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    
                    ZStack {
                        
                        TextField("Insert your friend's Code...", text: $friendCode)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            .cornerRadius(10) /// make the background rounded
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#FF8B8B"), lineWidth: 1)
                            )
                            
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        
                        Button {
                            withAnimation {
                                showAddFriendDialog = false
                            }
                        } label: {
                            ZStack {
                                Color(hex: "")
                                
                                Text("Cancel")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(hex: "#FDA3A3"))
                                
                            }.frame(width: 140, height: 40)
                                .cornerRadius(10) /// make the background rounded
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "#FDA3A3"), lineWidth: 2)
                                )
                        }
                        
                        Spacer()
                        
                        Button {
                            // add friend by code
                            if friednsViewModel.friends.count > 0 && !getIsPro() {
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .Purchase
                                }
                            } else {
                                friednsViewModel.addFriend(friendId: friendCode) { bool in
                                    if bool {
                                        withAnimation {
                                            showAddFriendDialog = false
                                        }
                                    } else {
                                        
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                Color(hex: "#FDA3A3")
                                
                                Text("Add")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                
                            }.frame(width: 140, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                    }
                }.frame(width: UIScreen.screenWidth - 82)
                    .padding(.vertical, 36)
                
            }
                .frame(width: UIScreen.screenWidth - 40, height: 200)
                .offset(y: showAddFriendDialog ? 0 : UIScreen.screenHeight)
            
            
        }
    }
    
    var friendsListView : some View {
        VStack {
            
            ScrollView {
                
                Spacer().frame(height: 48)
                
                if friednsViewModel.friends.count == 0 {
                    Spacer()
                        .frame(height: 180)
                    
                    Image("emptyWidgetList")
                        
                    
                    Spacer()
                        .frame(height: 30)
                    
                    
                    Text("You don’t added any friends yet")
                      .font(Font.custom("SF UI Text", size: 16))
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                    
                    Spacer()
                        .frame(height: 60)
                } else {
                    ForEach(friednsViewModel.friends, id: \.id) { friend in
                        
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
                                    Button("Remove friend") {
                                        // call api
                                        withAnimation {
                                            showRemoveFriendDialog = true
                                        }
                                        selectedFriendToRemove = friend
                                    }
                                } label: {
                                    Image(.img3Dots)
                                        
                                }

                                
                            }.padding()
                            
                        }.frame(width: UIScreen.screenWidth - 40, height: 72)
                            .onTapGesture {
                                if doNeedSelectFriend
                                {
                                    var flag = false
                                    for i in friednsViewModel.selectedFriends {
                                        if i.id == friend.id {
                                            flag = true
                                        }
                                    }
                                    if !flag {
                                        friednsViewModel.selectedFriends.append(friend)
                                    }
                                    dismiss()
                                }
                            }
                        
                    }
                }
                
                
                
            }
            
            Button(action: {
                withAnimation {
                    showAddFriendDialog = true
                }
            }, label: {
                Image(.btnAddNewFriends)
                    .resizable()
                    .frame(width: UIScreen.screenWidth - 44, height: 60)
            })
        }
    }
    
    
}

#Preview {
    FriendsScreen()
}
