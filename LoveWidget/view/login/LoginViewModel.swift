//
//  LoginViewModel.swift
//  LoveWidget
//
//  Created by enigma 1 on 8/29/23.
//

import Foundation
import Alamofire
import SwiftyJSON

let base_url = "http://157.90.30.203/widget-ios"


@MainActor
class LoginViewModel : ObservableObject {
    
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    @Published var token : String = ""
    @Published var userModel  :UserModel? = nil
    
    
    func loginWithEmail(email:String, password:String, onSuccess : @escaping (Bool)-> Void) {
        
        fetchLoginWithEmail(email: email, password: password) { dataState in
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
                        self.errorMessage = "Login Failed.."
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
        let url =  "\(base_url)/auth/skip-login"
        PostApiService<LoginResponseModel>(parameters: nil, header: nil, url: url)
            .fetch { dataState in
                
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
                            self.errorMessage = "Login Failed.."
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
    
    private func fetchLoginWithEmail(email:String, password : String, onResponse : @escaping (DataState<LoginResponseModel?, ErrorType, String>) -> Void) {
        
        let url =  "\(base_url)/auth/login"
        
        let parameters : [String:String] = [
            "email":email,
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
    
    
    
    
}


//{
//    "email": "mohodarabi@gmail.com",
//    "password": "123456789",
//    "playerId": "playerId"
//}

struct LoginRequestModel : Codable {
    
    var email:String
    var password: String
    var playerId:String
    
}


//{
//    "success": true,
//    "message": "user successfully singed up",
//    "user": {
//        "username": "guest-1693420436995",
//        "code": "1693420436995",
//        "profileImage": "http://157.90.30.203/widget-ios/userprofile/logo7.svg",
//        "id": "64ef8b9508142a82a9d4f1bc"
//    },
//    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NGVmOGI5NTA4MTQyYTgyYTlkNGYxYmMiLCJ0b2tlblR5cGUiOiJhY2Nlc3NfdG9rZW4iLCJpYXQiOjE2OTM0NzAwNTQsImV4cCI6MTY5MzQ4MjA1NH0.Af-nP7_nf44M6HtwcCiPaiRjQhG6kfkBo1js-zolu04"
//}


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
    
}
