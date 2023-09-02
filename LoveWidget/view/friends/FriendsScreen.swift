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
            
            friendsListView
                .onChange(of: showAddFriendDialog) { newValue in
                    if newValue {
                        friendCode = ""
                    }
                }
            
            addFriendDialog
            
        }
        .alert(friednsViewModel.errorMessage, isPresented: $friednsViewModel.isErrorOccurred) {
            Button("ok") {
                friednsViewModel.isErrorOccurred = false
            }
        }
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
                            
                            Image(.img3Dots)
                                .contextMenu(menuItems: {
                                    Button("Remove friend") {
                                        // call api
                                        friednsViewModel.deleteFriend(friendId: friend.id) { bool in
                                            if bool {
                                                
                                            } else {
                                                
                                            }
                                        }
                                    }
                                })
                            
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
