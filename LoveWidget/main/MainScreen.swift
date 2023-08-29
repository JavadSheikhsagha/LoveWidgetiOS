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
    
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onAppear {
                    
                }
            
            ScrollView(showsIndicators: false) {
                
                Spacer()
                    .frame(height: 48)
                VStack {
                    
                    Spacer()
                        .frame(height: 16)
                    
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
                                            
                                        } label: {
                                            Text("Logout")
                                        }
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Delete Account")
                                        }
                                        
                                    }
                                
                            }
                            
                            Spacer()
                        }
                        
                        VStack {
                            
                            Spacer()
                                .frame(height: 24)
                            
                            AsyncImage(url: URL(string: "imgUrl")!) { image in
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
                                    
                                    Text("Hello")
                                        .font(.system(size: 16))
                                    
                                    Spacer()
                                    
                                    Button {
                                        // edit name dialog
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
                                    
                                    Text("Hello")
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
