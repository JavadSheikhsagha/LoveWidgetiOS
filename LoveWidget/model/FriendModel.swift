//
//  FriendModel.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


struct GetFriendsResponseModel : Codable {
    
    var success:Bool?
    var message:String?
    var data : [UserModel]?
}

struct DeleteFriendResponseModel : Codable {
    
    var success:Bool?
    var message:String?
    var data : UserModel?
}

