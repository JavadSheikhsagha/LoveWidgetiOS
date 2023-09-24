//
//  SwiftUIView.swift
//  LoveWidget
//
//  Created by Javad on 9/6/23.
//

import SwiftUI
import LottieSwiftUI

struct ForgetPasswordScreen: View {
    
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var isButtonEnabled = false
    @State var isLoading = false
    @State var email: String = ""
    @State var playLottie = true
    
    var body: some View {
        ZStack {
            
            Color(hex: "#FEEAEA")
                .ignoresSafeArea()
                .onAppear {
                    
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            VStack {
                
                header
                
                Image("loginImage")
                
                Spacer()
                
                VStack(spacing: 12) {
                    
                    Text("Forget Password")
                      .font(
                        Font.custom("SF UI Text", size: 24)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                    
                    Spacer()
                        .frame(height: 14)
                    
                    Text("Please enter your Email address below to reset your password")
                      .font(Font.custom("SF UI  Text", size: 14))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                      .frame(width: 324, alignment: .top)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    ZStack {
                        
                        TextField(text: $email, prompt: Text("Email")) {
                            
                        }.textContentType(.emailAddress).padding()
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            .onChange(of: email) { newValue in
                                if textFieldValidatorEmail(newValue){
                                    isButtonEnabled = true
                                } else {
                                    isButtonEnabled = false
                                }
                            }
                            
                    }.cornerRadius(10) /// make the background rounded
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#FF8B8B"), lineWidth: 1)
                    )
                    
                    Spacer()
                        .frame(height: 44)
                    
                    FilledButton(text: "Send", isEnabled: $isButtonEnabled) {
                        if isButtonEnabled {
                            loginViewModel.sendForgetPassword(email: email) { bool in
                                if bool {
                                    withAnimation {
                                        mainViewModel.SCREEN_VIEW = .ResetPasswordScreen
                                    }
                                }
                            }
                        }
                        UIApplication.shared.endEditing()
                    }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    
                    
                    Spacer()
                    
                }
                
            }
            .alert(loginViewModel.errorMessage, isPresented: $loginViewModel.isErrorOccurred) {
                Button("ok") {
                    loginViewModel.isErrorOccurred = false
                }
            }.alert(loginViewModel.errorMessage, isPresented: $loginViewModel.isErrorOccurred) {
                Button("ok") {
                    loginViewModel.isErrorOccurred = false
                }
            }
            
            Color.white
                .ignoresSafeArea()
                .opacity(loginViewModel.isLoading ? 0.4 : 0.0)
                .offset(y: loginViewModel.isLoading ? 0.0 : UIScreen.screenHeight)
            
            LottieView(name: "loading2.json", play: $playLottie)
                .frame(width: 200, height: 200)
                .lottieLoopMode(.loop)
                .opacity(loginViewModel.isLoading ? 1.0 : 0.0)
                .offset(y: loginViewModel.isLoading ? 0 : UIScreen.screenHeight)
            

            
        }
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .Login
                }
            } label: {
                Image("iconBack")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
            }
            
            Spacer()

            Text(appName)
                .bold()
                .font(.system(size: 16))
                .opacity(0.0)
            
            Spacer()
            
            
            Menu {
                
            } label: {
                Image("img3Dots")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .opacity(0.0)
            }


            
        }
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}


