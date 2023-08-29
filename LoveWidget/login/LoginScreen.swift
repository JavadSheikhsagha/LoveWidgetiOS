//
//  LoginScreen.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI
import EnigmaSystemDesign

struct LoginScreen: View {
    
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
                        }.cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                        )
                        
                        
                        
                        ZStack {
                            
                            SecureField ("Password", text: $passwordText)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                            
                        }.cornerRadius(10) /// make the background rounded
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#6D8DF7"), lineWidth: 1)
                        )
                            
                    }
                    
                    
                    Button {
                        // login later
                        
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
                        
                    } label: {
                        Image("loginLaterButton")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 64, height: 55)
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                }
                
            }
            
            ActivityIndicator(isAnimating: $isLoading, style: .large)
                .opacity(isLoading ? 1.0 : 0.0)
            
            
        }
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
