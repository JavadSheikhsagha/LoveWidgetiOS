//
//  UserModel.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


struct UserModel: Codable {
    
    var username:String
    var code:String?
    var profileImage:String
    var id:String
    var isVerified: Bool?
    var email:String?
    
}


struct DeleteUserResponseModel : Codable {
    
    var success : Bool?
    var message:String
}


struct ChangeUsernameResponseModel : Codable {
    
    var success:Bool?
    var message:String?
    var data:UserModel?
}


