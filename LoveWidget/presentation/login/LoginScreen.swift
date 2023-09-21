//
//  LoginScreen.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import EnigmaSystemDesign
import LottieSwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var loginViewModel : LoginViewModel
    
    @State var isButtonEnabled = false
    @State var isLoading = false
    @State var passwordText = ""
    @State var email: String = ""
    @State var playLottie = true
    
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
                
                Spacer()
                    .frame(height: 36)
                
                Image("loginImage")
                
                Spacer()
                    .frame(height: 52)
                
                VStack(spacing: 16) {
                    
                    Text("Log in")
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
                                    if textFieldValidatorEmail(newValue) && passwordText.count > 5 {
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
                            
//                            SecureField ("Password", text: $passwordText)
//                                .padding()
//                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
//                                .onChange(of: passwordText) { newValue in
//                                    if textFieldValidatorEmail(email) && passwordText.count > 5 {
//                                        isButtonEnabled = true
//                                    } else {
//                                        isButtonEnabled = false
//                                    }
//                                }
                            loginPasswordTextFieldView(text: $passwordText,
                                                       title: "Password",
                                                       showTitle: false)
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: passwordText) { newValue in
                                    if textFieldValidatorEmail(email) && passwordText.count > 5 {
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
                            
                            Spacer()
                            
                            Text("forget password?")
                              .font(Font.custom("SF UI  Text", size: 12))
                              .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                              .onTapGesture {
                                  //go to forget password
                                  withAnimation {
                                      mainViewModel.SCREEN_VIEW = .ForgetPasswordScreen
                                  }
                              }
                            
                        }.padding(.horizontal, 32)
                    }
                    
                    FilledButton(text: "Log in", isEnabled: $isButtonEnabled) {
                        isButtonEnabled = false
                        loginViewModel.loginWithEmail(email: email, password: passwordText) { bool in
                            isButtonEnabled = true
                            if bool {
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .MainMenu
                                }
                            } else {
                                
                            }
                        }
                        UIApplication.shared.endEditing()
                    }.frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    
                    
                    
                    HStack {
                        Text("Don’t have an account? ")
                          .font(Font.custom("SF UI  Text", size: 12))
                          .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.1))
                        
                        Text("Sign up")
                            .font(Font.custom("SF UI  Text", size: 12))
                            .foregroundStyle(Color(hex:"#87A2FB"))
                            
                    }.onTapGesture {
                        withAnimation {
                            mainViewModel.SCREEN_VIEW = .SignUp
                        }
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
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

extension String {
    
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

struct loginPasswordTextFieldView: View {
    @Binding var text : String
    var title : String
    var showTitle : Bool = true
    var body: some View {
        VStack(spacing: 4) {
            if showTitle {
                HStack{
                    Text(title).font(.system(size: 14)).bold()
                        .font(.system(size: 12))
                    Spacer()
                }
            }
            
            ZStack(alignment: .center) {
                VStack {
                    Spacer().frame(height: 70)
                    HStack {
                        Spacer()
                    }
                }
                HybridTextField(text: $text, titleKey: title)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .frame(height: 70)
                VStack {
                    Spacer()
                }
                
            }
            
            
            HStack {
                
                
                
                Spacer()
            }
            
        }
    }
}

struct HybridTextField: View {
    @Binding var text: String
    @State var isSecure: Bool = true
    var titleKey: String
    var body: some View {
        HStack{
            Group{
//                if isSecure{
//                    SecureField(titleKey, text: $text)
//
//                }else{
//                    TextField(titleKey, text: $text, prompt: Text(titleKey))
//
//                }
                SecureEnhancedTextField(text: $text, isSecure: $isSecure, placeHolder: titleKey)
            }.animation(.easeInOut(duration: 0.1), value: isSecure)
            //Add any common modifiers here so they dont have to be repeated for each Field
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(uiImage: UIImage(named: !isSecure ? "iconOpenedEe" : "iconClosedEye")! )
                    
            })
        }//Add any modifiers shared by the Button and the Fields here
    }
}

struct SecureEnhancedTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isSecure : Bool
    var placeHolder : String
    
  
    init(text: Binding<String>, isSecure : Binding<Bool>,placeHolder: String) {
        self._text = text
        self.placeHolder = placeHolder
        self._isSecure = isSecure
  }

  func makeUIView(context: Context) -> ModifiedTextField {
    let textField = ModifiedTextField(frame: .zero)
    textField.delegate = context.coordinator
      textField.placeholder = placeHolder
      textField.font =  UIFont.init(name: "Helvetica Neue", size: 16.0)
      textField.isSecureTextEntry = isSecure
    return textField
  }
  

  func updateUIView(_ uiView: ModifiedTextField, context: Context) {
      uiView.isSecureTextEntry = isSecure
    uiView.text = text
  }


  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  
  class Coordinator: NSObject, UITextFieldDelegate {
    let parent: SecureEnhancedTextField

    init(_ parent: SecureEnhancedTextField) {
      self.parent = parent
    }
  

    func textFieldDidChangeSelection(_ textField: UITextField) {
      parent.text = textField.text ?? ""
    }
  }
}

class ModifiedTextField: UITextField {
  let padding = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5)

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: padding)
  }

  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: padding)
  }

  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: padding)
  }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
