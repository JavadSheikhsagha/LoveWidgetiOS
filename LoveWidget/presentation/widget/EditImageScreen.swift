//
//  EditImageScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/24/23.
//

import SwiftUI

struct EditImageScreen: View {
    
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
            
            Color(hex: "#FEEAEA")
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .onAppear {
                    print("here")
                }
            
            VStack {
                
                header
                
                Spacer()
                
                // view
                
                editImageView
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // view
                
                Spacer()
                
                // BottomViews
                
                WidgetEditImageFooter2()
                
            }
        }
    }
    
    var editImageView: some View {
        ZStack {
            Image(uiImage: widgetViewModel.selectedImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth - 40)
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
//                widgetViewModel.selectedImage = editQuoteView.clipShape(RoundedRectangle(cornerRadius: 10)).asImage()
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .UploadImageScreen
                }
            } label: {
                ZStack {
                    
                    Color(hex: "#FDA3A3")
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Next")
                        .foregroundStyle(.white)
                    
                }.frame(width: 100, height: 28)
                    .padding(.trailing, 16)
            }


            
        }
        .padding(.horizontal, 0)
    }
}

struct WidgetEditImageFooter2 : View {
    
    @EnvironmentObject var widgetViewModel : WidgetViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var txtIndex = 2
    
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FFDBDB")
                .opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .ignoresSafeArea()
                .onChange(of: txtIndex) { newValue in
                    if newValue == 0 {
                        withAnimation {
                            mainViewModel.SCREEN_VIEW = .ImageCropperView
                        }
                    }
                }
            
            ZStack {
                
                VStack {
                    ZStack {
                        Color(hex: "#FFDBDB")
                            .cornerRadius(22, corners: [.topLeft,.topRight])
                            .frame(height: 70)
                        
                        if txtIndex == 0 {
                            
                            HStack(spacing: 20) {
                                
                                ForEach(cropImageListOptions,id: \.self) { item in
                                    
                                    VStack(spacing: 4) {
                                        
                                        Image("icon\(item)")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        
                                        Text(item)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(hex: txtIndex == 0 ? "#FF8B8B" : "#767676"))
                                        
                                    }
                                }
                                
                            }.frame(height: 70)
                            
                        } else if txtIndex == 1 {
                            
                            HStack {
                                
                               
                            }
                            
                        } else if txtIndex == 2 {
                            HStack(spacing: 20) {
                                
                            }
                        }
                        
                    }.padding(.horizontal, 0)
                    
                    Spacer()
                }
                
                VStack {
                    
                    Spacer()
                    
                    HStack {
                      
                        Button {
                            withAnimation {
                                txtIndex = 0
                            }
                        } label: {
                            Text("Crop & Rotate")
                                .frame(width: 150)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: txtIndex == 0 ? "#FF8B8B" : "#767676"))
                        }
                        
                        Button {
                            withAnimation {
                                txtIndex = 2
                            }
                        } label: {
                            Text("Effect")
                                .frame(width: 150)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: txtIndex == 2 ? "#FF8B8B" : "#767676"))
                        }

                        
                    }
                    .padding(.horizontal, 24)
                    
                }.frame(height: 80)
                
            }
            
        }.frame(height: 150)
    }
    
    @State var cropImageListOptions = [
        "Original",
        "Free",
        "Square",
    ]
    
}


#Preview {
    EditImageScreen()
}
