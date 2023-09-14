//
//  LoginViewModel.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import OneSignalFramework

let base_url = "https://back.a2mp.site/widget-ios"


@MainActor
class LoginViewModel : ObservableObject {
    
    private let loginRepository = LoginRepository()
    
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    @Published var token : String = ""
    @Published var userModel : UserModel? = nil
    
    func changePasswordProfileScreen(password:String, oldPassword:String, onSuccess : @escaping (Bool)-> Void) {
        
        loginRepository.changePasswordProfileScreen(password: password, oldPassword: oldPassword){ dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            saveToken(token: data.accessToken ?? "")
                            saveUser(userModel: data.user)
                            self.token = getToken() ?? ""
                            self.userModel = loadUser()
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = data.message
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Login Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error?.localizedDescription) ?? ""
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
        
    }
    
    
    func resetPassword(password:String, onSuccess : @escaping (Bool)-> Void) {
        
        loginRepository.resetPassword(password: password) { dataState in
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    //save token
                    //save usermodel
                    if let data = data {
                        if data.success == true {
                            saveEmail(email: "")
                            saveToken(token: data.accessToken ?? "")
                            saveUser(userModel: data.user)
                            self.token = getToken() ?? ""
                            self.userModel = loadUser()
                            OneSignal.login(self.userModel?.id ?? "")
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = data.message
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Login Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error?.localizedDescription) ?? "Failed to change password"
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
    }
    
    func sendForgetPassword(email:String, onSuccess : @escaping (Bool)-> Void) {
        
        loginRepository.sendForgetPassword(email: email) { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    //save token
                    //save usermodel
                    if let data = data {
                        if data.success == true {
                            saveEmail(email: email)
                            self.isLoading = false
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = data.message
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "sending email Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error?.localizedDescription) ?? "sending email failed."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
    }
    
    
    func registerUser(email:String, password:String, onSuccess : @escaping (Bool)-> Void) {
        
        
        loginRepository.registerUser(email: email, password: password) { dataState in
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    //save token
                    //save usermodel
                    if let data = data {
                        if data.success == true {
                            saveToken(token: data.accessToken ?? "")
                            saveUser(userModel: data.user)
                            self.token = getToken() ?? ""
                            self.userModel = loadUser()
                            OneSignal.login(self.userModel?.id ?? "")
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = data.message
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Registration Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error?.localizedDescription) ?? "Failed to Register"
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
        
    }
    
    
    func loginWithEmail(email:String, password:String, onSuccess : @escaping (Bool)-> Void) {
        
        loginRepository.loginWithEmail(email: email, password: password) { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                //save token
                //save usermodel
                if let data = data {
                    if data.success == true {
                        saveToken(token: data.accessToken ?? "")
                        saveUser(userModel: data.user)
                        self.token = getToken() ?? ""
                        self.userModel = loadUser()
                        OneSignal.login(self.userModel?.id ?? "")
                        onSuccess(true)
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = data.message
                        onSuccess(false)
                    }
                    
                } else {
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = "Login Failed.."
                    onSuccess(false)
                }
                self.isLoading = false
                
            case .error(error: let error, message: let msg):
                self.isErrorOccurred = true
                self.isLoading = false
                self.errorMessage = msg ?? error.localizedDescription
                
            case .loading(message: _):
                self.isLoading = true
                self.isErrorOccurred = false
                self.errorMessage = ""
                
            case .idle(message: _):
                break
            }
        }
    }
    
    func skipLogin(onSuccess: @escaping (Bool) -> Void) {
        
        loginRepository.skipLogin { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    //save token
                    //save usermodel
                    if let data = data {
                        if data.success == true {
                            saveToken(token: data.accessToken ?? "")
                            saveUser(userModel: data.user)
                            self.token = getToken() ?? ""
                            self.userModel = loadUser()
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.isLoading = false
                            self.errorMessage = data.message
                            onSuccess(false)
                        }
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Login Failed.."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: let error, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? error!.localizedDescription) ?? "Failed to login.."
                    
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


struct LoginRequestModel : Codable {
    
    var email:String
    var password: String
    var playerId:String
    
}

struct LoginResponseModel : Codable {
    
    var statusCode: Int?
    var success:Bool?
    var message:String
    var user: UserModel?
    var accessToken:String?
}

struct UserModel: Codable {
    
    var username:String
    var code:String?
    var profileImage:String
    var id:String
    var isVerified: Bool?
    var email:String?
    
}
