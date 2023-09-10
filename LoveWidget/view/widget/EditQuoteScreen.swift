//
//  EditQuoteScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/5/23.
//

import SwiftUI
import UIKit

struct EditQuoteScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @Environment(\.displayScale) var displayScale
    
    @State var colorGradient : String = "colorBackground4"
    @State var fontColor : String = "textBlackColor"
    @State var textFont : String = "SF UI TEXT"
    @State var defaultTexts : String = ""
    
    @State var textFieldText = ""
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                Spacer()
                
                // view
                
                editQuoteView
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // view
                
                Spacer()
                
                // BottomViews
                
                WidgetEditScreenFooter(colorGradient: $colorGradient,
                                       fontColor: $fontColor,
                                       textFont: $textFont,
                                       defaultTexts: $defaultTexts)
                
            }
        }
    }
    
    var editQuoteView : some View {
        ZStack {
            
            ZStack {
                
                Image(colorGradient)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                TextField("Enter your text", text: $textFieldText)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 200)
                    .font(.custom(textFont, size: 22))
                    .foregroundStyle(Color(fontColor))
                    .opacity(textFieldText.count > 0 ? 0.0 : 1.0)
                
                Text(textFieldText)
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 200)
                    .font(.custom(textFont, size: 22))
                    .foregroundStyle(Color(fontColor))
                
            }
            
            Image(defaultTexts)
        }
    }
    
    var snapShotView : some View {
        ZStack {
            
            ZStack {
                
                Image(colorGradient)
                    .resizable()
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                
                TextField("Enter your text", text: $textFieldText)
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 200)
                    .font(.custom(textFont, size: 22))
                    .foregroundStyle(Color(fontColor))
                
            }
            
            Image(defaultTexts)
                .resizable()
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .WidgetSingle
                }
            } label: {
                Image("iconBack")
                    .frame(width: 64, height: 28)
                    .padding()
            }
            
            Spacer()
            
            Text(appName)
                .bold()
                .font(.system(size: 16))
            
            Spacer()
            
            Button {
                // save
                widgetViewModel.selectedImage = editQuoteView.clipShape(RoundedRectangle(cornerRadius: 10)).asImage()
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .UploadImageScreen
                }
            } label: {
                ZStack {
                    
                    Color(hex: "#6D8DF7")
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Save")
                        .foregroundStyle(.white)
                    
                }.frame(width: 100, height: 28)
                    .padding(.trailing, 16)
            }


            
        }
        .padding(.horizontal, 0)
    }
    
}

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.rootViewController?.view.addSubview(controller.view)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        controller.additionalSafeAreaInsets = UIEdgeInsets(top: -controller.view.safeAreaInsets.top, left: -controller.view.safeAreaInsets.left, bottom: -controller.view.safeAreaInsets.bottom, right: -controller.view.safeAreaInsets.right)
        
        let targetSize = controller.view.intrinsicContentSize
        controller.view.bounds = CGRect(origin: .zero, size: targetSize)
        controller.view.sizeToFit()
        
        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        
        return image
    }
}
extension UIView {
    func asImage() -> UIImage  {
   
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    EditQuoteScreen()
}



struct WidgetEditScreenFooter : View {
    
    @State var scrollPositionFont = 0
    @State var scrollPositionBackgroundColor = 0
    
    @Binding var colorGradient : String
    @Binding var fontColor : String
    @Binding var textFont : String
    @Binding var defaultTexts : String
    
    @State var txtIndex = 0
    
    
    var body: some View {
        ZStack {
            
            Color("headerBackgroundColor")
                .opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .ignoresSafeArea()
                .onChange(of: txtIndex) { newValue in
                    
                    if newValue != 3 {
                        defaultTexts = ""
                    } else {
                        defaultTexts = "default1"
                    }
                }
            
            ZStack {
                
                VStack {
                    ZStack {
                        Color("headerBackgroundColor")
                            .cornerRadius(22, corners: [.topLeft,.topRight])
                            .frame(height: 70)
                        
                        if txtIndex == 0 {
                            
                            HStack(spacing: 20) {
                                ScrollView(.horizontal,showsIndicators: false) {
                                    
                                    
                                    ScrollViewReader{ proxy in
                                        HStack {
                                            Spacer()
                                                .frame(width: 30)
                                            ForEach(backgroundColorList, id:\.self) { backgroundColor in
                                                ZStack {
                                                    
                                                    Button {
                                                        colorGradient = backgroundColor
                                                    } label: {
                                                        Image(backgroundColor)
                                                            .resizable()
                                                            .frame(width: 32, height: 32)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 5)
                                                                    .stroke(Color.red.opacity(0.7),
                                                                            lineWidth: colorGradient == backgroundColor ? 5.0 : 0.0
                                                                    )
                                                            ).clipShape(RoundedRectangle(cornerRadius: 5))
                                                        
                                                    }
                                                    
                                                }.frame(width: 32, height: 32)
                                                    .id(backgroundColor)
                                                
                                            }
                                            Spacer()
                                                .frame(width: 30)
                                                .onAppear {
                                                    proxy.scrollTo(colorGradient, anchor: .center)
                                                }
                                        }
                                    }
                                    
                                }
                            }.frame(height: 70)
                            
                        } else if txtIndex == 1 {
                            
                            HStack {
                                
                                ScrollView(.horizontal,showsIndicators: false) {
                                    
                                    ScrollViewReader { proxy in
                                        HStack {
                                            
                                            Spacer()
                                                .frame(width: 30)
                                            
                                            
                                            ForEach(textFontList, id: \.self) { fontText in
                                                Button {
                                                    withAnimation {
                                                        textFont = fontText
                                                    }
                                                } label: {
                                                    ZStack {
                                                        Text(fontText)
                                                            .font(.custom(fontText, size: 14))
                                                            .foregroundColor(Color("btnBackgroundAccentColor"))
                                                            .font(.system(size: 14))
                                                            .frame(width: 100,height: 40)
                                                    }
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(textFont == fontText ? Color.red.opacity(0.7) : (Color("btnBackgroundAccentColor")).opacity(0.7),
                                                                    lineWidth: 5.0
                                                            )
                                                    ).clipShape(RoundedRectangle(cornerRadius: 8))
                                                }.id(fontText)

                                            }
                                            .onAppear {
                                                proxy.scrollTo(textFont, anchor: .center)
                                            }
                                            
                                            Spacer()
                                                .frame(width: 30)
                                        }
                                    }
                                    
                                }.frame(height: 70)
                            }
                            
                        } else if txtIndex == 2 {
                            HStack(spacing: 20) {
                                ForEach(textColorList, id:\.self) { textColor in
                                    ZStack {
                                        
                                        Button {
                                            withAnimation(.easeIn(duration: 200)) {
                                                
                                            }
                                            fontColor = textColor
                                        } label: {
                                            Color(textColor)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.red.opacity(0.7),
                                                                lineWidth: textColor == fontColor ? 5.0 : 0.0
                                                        )
                                                ).clipShape(RoundedRectangle(cornerRadius: 5))
                                            
                                        }
                                        
                                    }.frame(width: 32, height: 32)
                                }
                            }
                        } else if txtIndex == 3 {
                            
                            HStack(spacing: 20) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(defaultTextList, id: \.self) { defaultText in
                                            HStack {
                                                Button {
                                                    
                                                    defaultTexts = defaultText
                                                } label: {
                                                    Image(defaultText)
                                                        .resizable()
                                                        .frame(width: 32, height: 32)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(Color.red.opacity(0.7),
                                                                        lineWidth: defaultText == defaultTexts ? 5.0 : 0.0
                                                                )
                                                        )
                                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                                }
                                            }
                                        }
                                    }.padding(.horizontal, 36)
                                }
                                
                                
                            }
                            
                        }
                    }.padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                VStack {
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            
                            Button {
                                withAnimation {
                                    txtIndex = 3
                                }
                            } label: {
                                Text("Default Text")
                                    .frame(width: 100)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(txtIndex == 3 ? "textColorAccent" : "textColorUnselected"))
                            }
                            
                            Button {
                                withAnimation {
                                    txtIndex = 0
                                }
                            } label: {
                                Text("Background")
                                    .frame(width: 100)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(txtIndex == 0 ? "textColorAccent" : "textColorUnselected"))
                            }

                                
                            Button {
                                withAnimation {
                                    txtIndex = 1
                                }
                            } label: {
                                Text("Text font")
                                    .frame(width: 100)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(txtIndex == 1 ? "textColorAccent" : "textColorUnselected"))
                            }

                                
                            
                            Button {
                                withAnimation {
                                    txtIndex = 2
                                }
                            } label: {
                                Text("Text Color")
                                    .frame(width: 100)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(txtIndex == 2 ? "textColorAccent" : "textColorUnselected"))
                            }

                            
                        }
                        .padding(.horizontal, 24)
                    }
                    
                }.frame(height: 80)
                
            }
            
        }.frame(height: 150)
    }
    
    @State var textColorList = [
        "textBlackColor",
        "textWhiteColor",
        "textBlueColor",
        "textRedColor",
        "textGreenColor",
        "textYellowColor"
    ]
    
    @State var backgroundColorList = [
        "bgColor1",
        "bgColor2",
        "bgColor3",
        "bgColor4",
        "bgColor5",
        "bgColor6",
        "bgColor7",
        "bgColor8",
        "bgColor9",
        "bgColor10",
        "bgColor11",
        "bgColor12",
        "bgColor13",
        "bgColor14",
        "bgColor15",
        "bgColor16",
        "bgColor17",
        "bgColor18",
        "bgColor19",
        "bgColor20",
        "bgColor21",
        "bgColor22",
        "bgColor23",
        "bgColor24",
        "bgColor25",
        "bgColor26",
        "bgColor27",
    ]
    
    @State var defaultTextList = [
        "default1",
        "default2",
        "default3",
        "default4",
        "default5",
        "default6",
        "default7",
        "default8",
        "default9",
        "default10",
        "default11",
    ]
    
    @State var textFontList = [
        "SF UI TEXT",
//        "SF Pro Text",
        "Wendy One",
        "Sacramento",
        "Purple Purse",
        "Kreon",
        "Yomogi",
    ]
    
}





extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
