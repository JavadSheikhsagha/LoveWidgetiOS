//
//  MainViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/29/23.
//

import Foundation


class MainViewModel : ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    
    @Published var widgets = [String]()
    
    @Published var SCREEN_VIEW : Screens = .Login
    
    func deleteUser(onSuccess : @escaping (Bool) -> Void) {
        
        let url =  "\(base_url)/auth/delete-account"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        PostApiService<LoginResponseModel>(parameters: nil, header: header, url: url)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        onSuccess(true)
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Delete user Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error!.localizedDescription) ?? "Failed to Delete user.."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
                
                
            }
        
    }
    
}


enum Screens {
    
    case MainMenu
    case Friends
    case WidgetSingle
    case Login
    case History 
    case CreateWidget
}
