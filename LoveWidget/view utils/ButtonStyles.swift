//
//  ButtonStyles.swift
//  LoveWidget
//
//  Created by Javad on 9/21/23.
//

import SwiftUI

struct FilledButton: View {
    
    var text:String
    var icon : String? = nil
    var colorBackground : String? = nil
    @Binding var isEnabled : Bool
    var btnSize: ButtonSizeType = .LARGE
    var onClicked : () -> Void
    
    
    var body: some View {
        
        Button(action: {
            if isEnabled {
                onClicked()
            }
        }, label: {
            ZStack {
                
                Color(hex: isEnabled ? (colorBackground == nil ? "#FDA3A3" : colorBackground)! : "#C7C7C7")
                
                HStack {
                    if let icon = icon {
                        
                    } else {
                        Text(text)
                            .font(.system(size: btnSize == .LARGE ? 20 : 16))
                            .foregroundStyle(.white)
                    }
                }
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

enum ButtonSizeType {
    case SMALL
    case LARGE
}

struct OutlineButton: View {
    
    var text:String
    var icon : String? = nil
    var onClicked : () -> Void
    
    var body: some View {
        
        Button(action: {
            onClicked()
        }, label: {
            ZStack {
                Color(hex: "")
                HStack {
                    if let icon = icon {
                        
                    } else {
                        Text(text)
                            .font(.system(size: 20))
                            .foregroundStyle(Color(hex: "#FDA3A3"))
                    }
                }
            }
            .cornerRadius(10) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#FDA3A3"), lineWidth: 2)
            )
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

