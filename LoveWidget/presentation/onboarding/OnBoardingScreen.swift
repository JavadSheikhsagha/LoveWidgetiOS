//
//  OnBoarding.swift
//  LoveWidget
//
//  Created by Javad on 9/26/23.
//

import SwiftUI
import LottieSwiftUI

struct OnBoardingScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var onBoardingIndex = 0
    
    var body: some View {
        ZStack {
            
            Color(hex:"#FEEAEA")
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                    .frame(height: 42)
                
                onBoardingScreens
                
                Spacer()
                
                onBoardingIndicator
                
                Spacer()
                    .frame(height: 80)
                
            }
        }
        
        VStack {
            
            Spacer()
            
            footer
            
        }.ignoresSafeArea()
    }
    
    var onBoardingIndicator : some View {
        HStack {
            ForEach(0..<items.count) { index in
                
                Circle()
                    .foregroundColor(onBoardingIndex == index ? Color(hex: "#FDA3A3") : Color(hex: "#FEEAEA"))
                    .overlay {
                        if onBoardingIndex != index {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: 1)
                        }
                    }.frame(width:11, height:11)
                    
            }
        }
    }
    
    var footer : some View {
        ZStack(alignment:.bottom) {
            
            Color(hex:"#FFDBDB")
                .frame(height: 90)
                
            
            VStack {
                HStack(alignment: .top) {
                    
                    Button(action: {
                        //goto login
                        withAnimation {
                            mainViewModel.SCREEN_VIEW = .Login
                        }
                        watchedOnBoarding()
                    }, label: {
                        Text("Skip")
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: "#EE5555"))
                            .padding(30)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        if onBoardingIndex < 4 {
                            withAnimation {
                                onBoardingIndex+=1
                            }
                        } else {
                            //goto login
                            watchedOnBoarding()
                            withAnimation {
                                mainViewModel.SCREEN_VIEW = .Login
                            }
                        }
                    }, label: {
                        Text("Next")
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: "#EE5555"))
                            .padding(30)
                    })
                    
                }
                
                Spacer()
                    .frame(height: 12)
            }
        }
    }
    
    var onBoardingScreens : some View {
        VStack {
            
            Image(items[onBoardingIndex].image)
                .resizable()
                .frame(width: UIScreen.screenWidth - 124, height: UIScreen.screenWidth - 124)
            
            Spacer()
                .frame(height: 48)
            
            Text(items[onBoardingIndex].title)
                .font(.system(size: 18))
              .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
            
            Spacer()
                .frame(height: 45)
            
            Text(items[onBoardingIndex].description)
                .font(.system(size: 18))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
              .frame(width: 291, alignment: .top)
            
        }
    }
    
    let items = [
        OnBoardingItemModel(title: "Welcome to Love Widget",
                            description: "You always have a place on your phone for someone you love.",
                            image: "imgIntroP1"),
        OnBoardingItemModel(title: "You can send photos to your friends",
                            description: "You can easily send your photos to your friends widget and edit them.",
                            image: "imgIntroP2"),
        OnBoardingItemModel(title: "You can send quotes to your friends",
                            description: "Send beautiful texts to your friends, family and love, you can simply write your favorite text.",
                            image: "imgIntroP3"),
        OnBoardingItemModel(title: "You can send drawing to your friends",
                            description: "Draw and share it with your friends. They can like your drawings. Very fast and easy.",
                            image: "imgIntroP4"),
        OnBoardingItemModel(title: "You can send quotes to your friends",
                            description: "You can use cute action to show your mood. There are interesting and funny animations in this section.",
                            image: "imgIntroP5"),
    ]
}

#Preview {
    OnBoardingScreen()
}


struct OnBoardingItemModel : Identifiable {
    var id = UUID().uuidString
    let title:String
    let description:String
    let image:String
    
}
