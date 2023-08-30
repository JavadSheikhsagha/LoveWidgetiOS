//
//  FriendsScreen.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import SwiftUI

struct FriendsScreen: View {
    
    @EnvironmentObject var friednsViewModel : FriendsViewModel
    
    var body: some View {
        ZStack {
            
            Color(hex: "#F9FBFD")
                .ignoresSafeArea()
            
            VStack {
                
                ScrollView {
                    
                    Spacer().frame(height: 24)
                    
                    ForEach(friednsViewModel.friends, id: \.self) { friend in
                        
                        ZStack {
                            
                            Color(hex: "#EEF1FF")
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            HStack(spacing: 14) {
                                
                                Image(.imgUserSample)
                                    .resizable()
                                    .frame(width: 52, height: 52)
                                
                                Text(friend)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))

                                Spacer()
                                
                                Image(.img3Dots)
                                    .contextMenu(menuItems: {
                                        Button("Remove friend") {
                                            // call api
                                            
                                        }
                                    })
                                
                            }.padding()
                            
                        }.frame(width: UIScreen.screenWidth - 40, height: 72)
                        
                    }
                    
                }
                
                Button(action: {
                    
                }, label: {
                    Image(.btnAddNewFriends)
                        .resizable()
                        .frame(width: UIScreen.screenWidth - 44, height: 55)
                })
            }
            
        }
    }
    
    
}

#Preview {
    FriendsScreen()
}
