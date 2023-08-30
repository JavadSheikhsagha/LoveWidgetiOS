//
//  ContentView.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel : MainViewModel
    var body: some View {
        ZStack {
            
            switch mainViewModel.SCREEN_VIEW {
                case .MainMenu:
                    MainScreen()
                case .Friends:
                    FriendsScreen()
                case .WidgetSingle:
                    WidgetSingleScreen()
                case .Login:
                    LoginScreen()
                case .History:
                    WidgetHistoryScreen()
                case .CreateWidget:
                    CreateWidgetScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
