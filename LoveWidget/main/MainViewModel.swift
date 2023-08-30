//
//  MainViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/29/23.
//

import Foundation


class MainViewModel : ObservableObject {
    
    @Published var isLoading = false
    @Published var widgets = [String]()
    
    @Published var SCREEN_VIEW : Screens = .Login
    
}


enum Screens {
    
    case MainMenu
    case Friends
    case WidgetSingle
    case Login
    case History 
    case CreateWidget
}
