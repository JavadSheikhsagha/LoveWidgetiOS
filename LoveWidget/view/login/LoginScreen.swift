//
//  LoginScreen.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import EnigmaSystemDesign

struct LoginScreen: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    @EnvironmentObject var loginViewModel : LoginViewModel
    
    @State var isButtonEnabled = false
    @State var isLoading = false
    @State var passwordText = ""
    @State var email: String = ""
    
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
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width)
                
                Spacer()
                
                VStack(spacing: 16) {
                    
                    
                    
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
                            
                            SecureField ("Password", text: $passwordText)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                                .onChange(of: passwordText) { newValue in
                                    if textFieldValidatorEmail(email) && newValue.isValidPassword() {
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
                            
                    }
                    
                    
                    Button {
                        loginViewModel.loginWithEmail(email: email, password: passwordText) { bool in
                            if bool {
                                withAnimation {
                                    mainViewModel.SCREEN_VIEW = .MainMenu
                                }
                            } else {
                                
                            }
                        }
                        UIApplication.shared.endEditing()
                        
                    } label: {
                        ZStack {
                            
                            Color(hex:  isButtonEnabled ? "#6D8DF7" : "#C7C7C7")
                            
                            Text("Log in")
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
            
            
            ActivityIndicator(isAnimating: $loginViewModel.isLoading, style: .large)
                .opacity(isLoading ? 1.0 : 0.0)
            
            
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
