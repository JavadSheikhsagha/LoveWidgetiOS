//
//  SignupScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/6/23.
//

import SwiftUI
import LottieSwiftUI

struct SignupScreen: View {
    
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var isButtonEnabled = false
    @State var isLoading = false
    @State var passwordText = ""
    @State var confirmPasswordText = ""
    @State var email: String = ""
    @State var playLottie = true
    @State var isTermsAndConditionsChecked = true
    
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
                
                Image("loginImage")
                
                Spacer()
                
                VStack(spacing: 12) {
                    
                    Text("Sign up")
                      .font(
                        Font.custom("SF UI Text", size: 24)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                    
                    Spacer()
                        .frame(height: 14)
                    
                    VStack(spacing: 12) {
                        
                        // two texts
                        ZStack {
                            
                            TextField(text: $email, prompt: Text("Email")) {
                                
                            }.textContentType(.emailAddress).padding()
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: email) { newValue in
                                    if textFieldValidatorEmail(newValue) 
                                        && passwordText.count > 5
                                        && passwordText == confirmPasswordText
                                        && isTermsAndConditionsChecked {
                                        isButtonEnabled = true
                                    } else {
                                        isButtonEnabled = false
                                    }
                                }
                                
                        }.cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: 1)
                        )
                        
                        ZStack {
                            
                            loginPasswordTextFieldView(text: $passwordText,
                                                       title: "Password",
                                                       showTitle: false)
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: passwordText) { newValue in
                                    if textFieldValidatorEmail(email)
                                        && passwordText.count > 5
                                        && passwordText == confirmPasswordText
                                        && isTermsAndConditionsChecked  {
                                        isButtonEnabled = true
                                    } else {
                                        isButtonEnabled = false
                                    }
                                }
                            
                        }.cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: 1)
                        )
                        
                        ZStack {
                            
                            loginPasswordTextFieldView(text: $confirmPasswordText,
                                                       title: "Confirm Password",
                                                       showTitle: false)
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: confirmPasswordText) { newValue in
                                    if textFieldValidatorEmail(email)
                                        && passwordText.count > 5
                                        && passwordText == confirmPasswordText
                                        && isTermsAndConditionsChecked  {
                                        isButtonEnabled = true
                                    } else {
                                        isButtonEnabled = false
                                    }
                                }
                            
                        }.cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#FDA3A3"), lineWidth: 1)
                        )
                        
                    }
                    
                    FilledButton(text: "Sign up", isEnabled: $isButtonEnabled, onClicked: {
                        if isButtonEnabled {
                            isButtonEnabled = false
                            loginViewModel.registerUser(email: email, password: passwordText) { bool in
                                isButtonEnabled = true
                                if bool {
                                    withAnimation {
                                        mainViewModel.SCREEN_VIEW = .MainMenu
                                    }
                                }
                            }
                        }
                        UIApplication.shared.endEditing()
                    })
                    .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    .onChange(of: isTermsAndConditionsChecked) { newValue in
                        if textFieldValidatorEmail(email)
                            && passwordText.count > 5
                            && passwordText == confirmPasswordText
                            && isTermsAndConditionsChecked {
                            
                            isButtonEnabled = true
                        } else {
                            isButtonEnabled = false
                        }
                    }
                    
                    OutlineButton(text: "Login later") {
                        UIApplication.shared.endEditing()
                        if !loginViewModel.isLoading {
                            loginViewModel.skipLogin(onSuccess: { bool in
                                if bool {
                                    withAnimation {
                                        mainViewModel.SCREEN_VIEW = .MainMenu
                                    }
                                } else {
                                    
                                }
                            })
                        }
                        
                        
                    }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    
                    
                    HStack {
                        Text("Already have an account? ")
                          .font(Font.custom("SF UI  Text", size: 12))
                          .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                        
                        Text("Log in")
                            .font(Font.custom("SF UI  Text", size: 14))
                            .foregroundStyle(Color(hex:"#FF8B8B"))
                            .onTapGesture {
                                // go to sign up
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .Login
                                }
                            }
                    }
                    
                    Spacer()
                        .frame(height: 48)
                    
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

#Preview {
    SignupScreen()
}
