//
//  LoginModel.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


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
