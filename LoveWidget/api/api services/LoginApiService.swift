//
//  LoginApiService.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol LoginApiService {
    
    func changePasswordProfileScreen(password:String,
                                     oldPassword:String,
                                     onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void)
    func resetPassword(password:String,
                       onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void)
    func sendForgetPassword(email:String,
                            onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void)
    func registerUser(email:String,
                      password:String,
                      onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void)
    func loginWithEmail(email:String,
                                     password : String,
                                     onResponse : @escaping (DataState<LoginResponseModel?, ErrorType, String>) -> Void)
    func skipLogin(onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void)
}


class LoginApiService_Impl : LoginApiService {
    
    func skipLogin(onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url =  "\(base_url)/auth/skip-login"
        
        PostApiService<LoginResponseModel>(parameters: nil, header: nil, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func loginWithEmail(email: String,
                        password: String,
                        onResponse: @escaping (DataState<LoginResponseModel?, ErrorType, String>) -> Void) {
        
        let url =  "\(base_url)/auth/login"
        let parameters : [String:String] = [
            "email":email.lowercased(),
            "password":password,
            "playerId":"pid"
        ]
        
        onResponse(.loading(message: ""))
        
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let data = MyDecoder<LoginResponseModel>().decodeJSON(json: response.data!)
                
                switch data {
                    case .success(let data):
                    onResponse(DataState.success(data: data, message: ""))
                    case .failure(let error):
                    print("failed to parse")
                    onResponse(DataState.error(error: ErrorType.parseError(error?.localizedDescription ?? "Failed to parse json"), message: "Failed to parse json"))
                }
                
            case .failure(let error):
                print("failed to recieve, \(error.localizedDescription)")
                onResponse(DataState.error(error: ErrorType.httpError(error.responseCode), message: "an error occurred during login"))
            }
            
        }
    }
    
    
    
    func registerUser(email: String,
                      password: String,
                      onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/auth/signup"
        let parameter = [
            "email":email.lowercased(),
            "password":password,
            "playerId":"pid"
        ]
        
        PostApiService<LoginResponseModel>(parameters: parameter, header: nil, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func sendForgetPassword(email: String,
                            onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/auth/send-forget-email"
        let parameter = [
            "email":email.lowercased(),
        ]
        
        PostApiService<LoginResponseModel>(parameters: parameter, header: nil, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func resetPassword(password: String, 
                       onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/auth/forget-password"
        let parameter = [
            "email":loadEmail()?.lowercased() ?? "",
            "password":password,
        ]
        
        PostApiService<LoginResponseModel>(parameters: parameter, header: nil, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func changePasswordProfileScreen(password: String,
                                     oldPassword: String, 
                                     onResponse: @escaping (DataState<LoginResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/auth/edit-password"
        let parameter = [
            "password":password,
            "oldPassword":oldPassword
        ]
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        PostApiService<LoginResponseModel>(parameters: parameter, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    
    
}
