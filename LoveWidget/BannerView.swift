//
//  BannerView.swift
//  LoveWidget
//
//  Created by Javad on 9/4/23.
//

import Foundation
import SwiftUI

struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }

    enum BannerType {
        case info
        case warning
        case success
        case error

        var tintColor: Color {
            switch self {
            case .info:
                return Color(red: 67/255, green: 154/255, blue: 215/255)
            case .success:
                return Color.green
            case .warning:
                return Color.yellow
            case .error:
                return Color.red
            }
        }
    }

struct BannerModifier: ViewModifier {

    @Binding var data: BannerData
    @Binding var show: Bool


    @State var task: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            if show {
                VStack {
                    HStack {
                        Image(.imgSuccessBanner)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                              .font(Font.custom("SF UI Text", size: 14))
                              .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                        }
                        Spacer()
                        Image(.imgClosebanner)
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data.type == .success ? Color(hex: "#EEFFF3") : Color(red: 1, green: 0.75, blue: 0.8))
                    .cornerRadius(12) /// make the background rounded
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(data.type == .success ? Color(hex: "#23A047") : Color(red: 1, green: 0.51, blue: 0.6), lineWidth: 1)
                    )
                    .shadow(radius: 20)
                    Spacer()
                }
                .padding()
                .animation(.easeInOut(duration: 1.2))
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))

                
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear {
                    self.task = DispatchWorkItem {
                        withAnimation {
                            self.show = false
                        }
                    }
                    // Auto dismiss after 5 seconds, and cancel the task if view disappear before the auto dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: self.task!)
                }
                .zIndex(5)
                .onDisappear {
                    self.task?.cancel()
                }
            }
            content
        }
    }
}

extension View {
    func banner(data: Binding<BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}
