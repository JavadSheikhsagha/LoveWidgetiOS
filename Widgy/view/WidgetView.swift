//
//  WidgetView.swift
//  WidgyExtension
//
//  Created by Javad on 9/14/23.
//

import Foundation
import SwiftUI
import WidgetKit


struct WidgyEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        ZStack {
            
            if let widget = entry.widgetModel  {
                
                if widget.contents?.data != nil {
//                    NetworkImage(url: URL(string: "https://i.stack.imgur.com/Tq8IR.png"))
                    ZStack(alignment:.bottomTrailing) {
                        GeometryReader { proxy in
                            NetworkImage(url: URL(string: widget.contents!.data ?? "imageUrl"))
                                .frame(width: proxy.frame(in: .local).width, height: proxy.frame(in: .local).height)
                        }
                        
                        VStack {
                            HStack {
                                
                                Button(intent: UpdateWidgetIntent(widgetId: widget.id ?? "")) {
                                    VStack {
                                        Image("btnReload")
                                    }
                                }
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Button(intent: ReactToWidgetIntent(widgetId: widget.id ?? "",
                                                                   contentId: widget.contents?.id ?? "")) {
                                    VStack {
                                        if widget.contents?.reaction ?? 0 > 0 {
                                            Image(.imgLikeFilled)
                                        } else {
                                            Image(.imgLikeBorder)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    GeometryReader { proxy in
                        Image(.imgWidgetEmptyBg)
                            .resizable()
                    }
                    
                }
                
            } else {
                Image(.configureWidgetBg)
            }
            
            
        }
    }
}

struct NetworkImage: View {

  let url: URL?

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
         .aspectRatio(contentMode: .fill)
      }
      else {
          VStack {
              Image(.imgUserSample)
              Text("Loading..")
                  .font(.system(size: 13))
          }
      }
    }
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

