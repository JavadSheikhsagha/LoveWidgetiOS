//
//  ResetPasswordScreen.swift
//  LoveWidget
//
//  Created by Javad on 9/6/23.
//

import SwiftUI
import LottieSwiftUI

struct ResetPasswordScreen: View {
    
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var mainViewModel : MainViewModel
    
    @State var isButtonEnabled = false
    @State var isLoading = false
    @State var showSuccessDialog = false
    @State var passwordText: String = ""
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
                    
                    Text("Change Password")
                      .font(
                        Font.custom("SF UI Text", size: 24)
                          .weight(.semibold)
                      )
                      .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    ZStack {
                        
                        loginPasswordTextFieldView(text: $passwordText,
                                                   title: "",
                                                   showTitle: false)
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            .onChange(of: passwordText) { newValue in
                                if passwordText.count > 5 {
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
                    
                    FilledButton(text: "Save", isEnabled: $isButtonEnabled) {
                        if isButtonEnabled {
                            loginViewModel.resetPassword(password: passwordText) { bool in
                                if bool {
                                    withAnimation {
                                        showSuccessDialog = true
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

            
            ZStack {
                
                Color.black.opacity(showSuccessDialog ? 0.5 : 0.0)
                    
                    .onTapGesture {
                        withAnimation {
                            showSuccessDialog = false
                        }
                    }
                    .ignoresSafeArea()
                
                
                successDialog
                
                
            }
            .offset(y: showSuccessDialog ? 0.0 : UIScreen.screenHeight)
            .onChange(of: showSuccessDialog) { newValue in
                if !newValue {
                    withAnimation {
                        mainViewModel.SCREEN_VIEW = .MainMenu
                    }
                }
            }
            
        }
    }
    
    var successDialog : some View {
        ZStack {
            
            Color(hex: "#EEF1FF")
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    withAnimation {
                        showSuccessDialog = false
                    }
                }
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showSuccessDialog = false
                        }
                    }, label: {
                        Image(.btnCloseDialog)
                    })
                }.padding()
                
                Image(.imgSuccess)
                
                Spacer()
                    .frame(height: 32)
                    
                Text("New password sent\nsuccessfully")
                  .font(
                    Font.custom("SF UI Text", size: 18)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                
                Spacer()
                    .frame(height: 20)
                
                Text("The new password has been successfully sent \nto your email. You can view it through \nthe spam section of the email.")
                  .font(Font.custom("SF UI Text", size: 14))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                  .frame(width: 241, alignment: .top)
                
                Spacer()
                    .frame(height: 20)
                
            }
            
        }.frame(width: UIScreen.screenWidth - 64, height: 380.0)
    }
    
    var header: some View {
        HStack {
            
            Button {
                //back to main
                withAnimation {
                    mainViewModel.SCREEN_VIEW = .ForgetPasswordScreen
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

#Preview {
    ResetPasswordScreen()
}
