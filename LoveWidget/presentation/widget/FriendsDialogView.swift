//
//  FriendsDialogView.swift
//  LoveWidget
//
//  Created by Javad on 10/21/23.
//

import SwiftUI

struct FriendsDialogView: View {
    
    @EnvironmentObject var friendViewModel : FriendsViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    
    @Binding var showFriendsDialog : Bool
    @State var showFriendsBottomSheet : Bool = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FFF8F8")
                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack {
                
                Spacer()
                    .frame(height: 8)
                
                Text("Friends")
                    .font(.system(size: 16))
                  .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                
                widgetMembersriendsList
                
                Spacer()
                    .frame(height: 32)
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showFriendsDialog = false
                        }
                    }, label: {
                        ZStack {
                            Color(hex: "")
                            HStack {
                                Text("Cancel")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color(hex: "#FDA3A3"))
                            }
                        }
                        .cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: 2)
                        )
                    })
                    .frame(width: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button(action: {
                        showFriendsBottomSheet = true
                    }, label: {
                        ZStack {
                            
                            Color(hex: "#FDA3A3")
                            
                            HStack {
                                Text("Add Friend")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                            }
                        }
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 10)).frame(width: 140)
                    
                    Spacer()
                }
                .frame(height: 38)
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: 32)
                
            }.frame(height: UIScreen.screenWidth - 20)
                .sheet(isPresented: $showFriendsBottomSheet) {
                    FriendsScreen(doNeedSelectFriend: true)
                }
                .onChange(of: friendViewModel.selectedFriends) { oldValue, newValue in
                    if newValue.count > oldValue.count {
                        widgetViewModel.getSingleWidgetData!.members.append(newValue.last!)
                        widgetViewModel.editWidgetViewers(friendIds: widgetViewModel.getSingleWidgetData!.members.map({ item in
                            return item.id
                        })) { bool in
                            
                        }
                    }
                    
                }
        }
    }
    
    var widgetMembersriendsList : some View {
        
        VStack {
            
            ScrollView {
                VStack {
                    
                    ForEach(widgetViewModel.getSingleWidgetData?.members ?? [], id: \.id) { friend in
                        
                        if friend.id != loadUser()?.id {
                            Spacer()
                                .frame(height: 24)
                            
                            ZStack {
                                
                                Color(hex: "#FFDBDB")
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
                                            widgetViewModel.getSingleWidgetData!.members = widgetViewModel.getSingleWidgetData!.members.filter({ item in
                                                return item.id != friend.id
                                            })
                                            // request to server
                                            widgetViewModel.editWidgetViewers(friendIds: widgetViewModel.getSingleWidgetData!.members.map({ item in
                                                return item.id
                                            })) { bool in
                                                
                                            }
                                        }
                                    } label: {
                                        Image(.img3Dots)
                                    }
                                    
                                }.padding()
                                
                            }.frame(width: UIScreen.screenWidth - 80, height: 72)
                                .onAppear(perform: {
                                    print("here is tyour friend")
                                })
                        }
                    }
                    
                }
            }
        }
    }
}
