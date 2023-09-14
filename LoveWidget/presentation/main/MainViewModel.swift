//
//  MainViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/29/23.
//

import Foundation


class MainViewModel : ObservableObject {
    
    private let mainRepository = MainRepository()
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    
    @Published var widgets = [String]()
    
    @Published var BACKSTACK_PURCHASE : Screens? = nil
    @Published var SCREEN_VIEW : Screens = .Login
    
    func deleteUser(onSuccess : @escaping (Bool) -> Void) {
        
        mainRepository.deleteUser { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = "Delete user Failed.."
                            onSuccess(false)
                        }
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
    
    func changeUsername(newUsername:String, onSuccess: @escaping (Bool)-> Void) {
        
        mainRepository.changeUsername(newUsername: newUsername) { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            saveUser(userModel: data.data)
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = "Change username Failed."
                            onSuccess(false)
                        }
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Change username Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error!.localizedDescription) ?? "Failed to Change username.."
                    
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
    case SignUp
    case History
    case Profile
    case Purchase
    case CreateWidget
    case UploadImageScreen
    case EditQuoteScreen
    case ForgetPasswordScreen
    case ResetPasswordScreen
}


