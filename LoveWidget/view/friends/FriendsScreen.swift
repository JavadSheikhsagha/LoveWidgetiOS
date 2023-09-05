//
//  FriendsScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI

struct FriendsScreen: View {
    
    @EnvironmentObject var friednsViewModel : FriendsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var showAddFriendDialog = false
    @State var showRemoveFriendDialog = false
    @State var selectedFriendToRemove : UserModel? = nil
    @State var friendCode = ""
    
    var doNeedSelectFriend = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#F9FBFD")
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
            
            
        }
        .alert(friednsViewModel.errorMessage, isPresented: $friednsViewModel.isErrorOccurred) {
            Button("ok") {
                friednsViewModel.isErrorOccurred = false
            }
        }
    }
    
    var removeFriendDialog : some View {
        ZStack {
            
            Color(hex: "#FFFFFF")
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
                        Image("btnDelete")
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
                
                Color(hex: "#EEF1FF")
                    .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    
                    ZStack {
                        
                        TextField("Insert your friend's Code...", text: $friendCode)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            .cornerRadius(10) /// make the background rounded
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                            )
                            
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        
                        Button {
                            // add friend by code
                            friednsViewModel.addFriend(friendId: friendCode) { bool in
                                if bool {
                                    withAnimation {
                                        showAddFriendDialog = false
                                    }
                                } else {
                                    
                                }
                            }
                        } label: {
                            Image(.btnAdd)
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 64, height: 55)
                        }

                        
                        Button {
                            withAnimation {
                                showAddFriendDialog = false
                            }
                        } label: {
                            Image(.btnCancelBig)
                                .resizable()
                                .frame(width: UIScreen.screenWidth - 64, height: 55)
                        }

                        
                    }
                }.padding(.horizontal, 20)
                    .padding(.vertical, 36)
                
            }
                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 64)
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
                        
                        ZStack {
                            
                            Color(hex: "#EEF1FF")
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
                                if doNeedSelectFriend {
                                    friednsViewModel.selectedFriend = friend
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
                    .frame(width: UIScreen.screenWidth - 44, height: 55)
            })
        }
    }
    
    
}

#Preview {
    FriendsScreen()
}
