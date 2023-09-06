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
    @State var isTermsAndConditionsChecked = false
    
    var body: some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
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
                                .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                        )
                        
                        ZStack {
                            
                            SecureField ("Password", text: $passwordText)
                                .padding()
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
                                .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                        )
                        
                        ZStack {
                            
                            SecureField ("Confirm Password", text: $confirmPasswordText)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: confirmPasswordText) { newValue in
                                    if textFieldValidatorEmail(email) 
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
                                .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                        )
                            
                        HStack {
                            
                            Button {
                                isTermsAndConditionsChecked.toggle()
                            } label: {
                                Image(isTermsAndConditionsChecked ? .fillCheck : .emptyCheck)
                            }

                            Text("Agree all terms & conditions")
                              .font(Font.custom("SF UI Text", size: 12))
                              .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            
                            Spacer()
                            
                        }.padding(.horizontal, 32)
                    }
                    
                    
                    Button {
                        if isButtonEnabled {
                            // sign up request
                        }
                        UIApplication.shared.endEditing()
                        
                    } label: {
                        ZStack {
                            
                            Color(hex:  isButtonEnabled ? "#6D8DF7" : "#C7C7C7")
                            
                            Text("Sign up")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            
                        }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Button {
                        // login later
//                        withAnimation {
//                            mainViewModel.SCREEN_VIEW = .MainMenu
//                        }
                        
                        UIApplication.shared.endEditing()
                        loginViewModel.skipLogin(onSuccess: { bool in
                            if bool {
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .MainMenu
                                }
                            } else {
                                
                            }
                        })
                        
                        
                    } label: {
                        Image("loginLaterButton")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    }
                    
                    
                    HStack {
                        Text("Already have an account? ")
                          .font(Font.custom("SF UI  Text", size: 12))
                          .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                        
                        Text("Log in")
                            .font(Font.custom("SF UI  Text", size: 12))
                            .foregroundStyle(Color(hex:"#87A2FB"))
                            .onTapGesture {
                                // go to sign up
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .Login
                                }
                            }
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
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
