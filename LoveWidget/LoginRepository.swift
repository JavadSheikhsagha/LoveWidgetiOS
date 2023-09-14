//
//  LoginRepository.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation

class LoginRepository : LoginApiService {

    
    private let loginApiService = LoginApiService_Impl()
    
    
    func skipLogin(onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        loginApiService.skipLogin(onResponse: onResponse)
    }
    
    func changePasswordProfileScreen(password: String,
                                     oldPassword: String,
                                     onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        loginApiService.changePasswordProfileScreen(password: password, oldPassword: oldPassword, onResponse: onResponse)
    }
    
    func resetPassword(password: String,
                       onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        loginApiService.resetPassword(password: password, onResponse: onResponse)
    }
    
    func sendForgetPassword(email: String,
                            onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        loginApiService.sendForgetPassword(email: email, onResponse: onResponse)
    }
    
    func registerUser(email: String,
                      password: String,
                      onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        loginApiService.registerUser(email: email, password: email, onResponse: onResponse)
    }
    
    func loginWithEmail(email: String,
                        password: String,
                        onResponse: @escaping (DataState<LoginResponseModel?, ErrorType, String>) -> Void) {
        loginApiService.loginWithEmail(email: email, password: password, onResponse: onResponse)
    }
    
    
}
