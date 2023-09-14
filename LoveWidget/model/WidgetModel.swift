//
//  WidgetModel.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


struct CreateWidgetResponseModel : Codable {
    let success:Bool?
    let message:String?
    let data : WidgetServerModel?
}

struct WidgetServerModel: Codable {
    let name:String?
    let creator:String?
    var contents:ContentModel?
    let reactions:[String]?
    let id:String?
    let member : String?
}

struct DeleteWidgetResponseModel: Codable {
    var success: Bool?
    var message:String?
}

struct GetAllWidgetResponseModel : Codable {
    let success:Bool?
    let message:String?
    let data: [WidgetServerModel]?
}

struct AddFriendToWidgetResponse : Codable {
    let success:Bool?
    let message:String?
}


struct ContentModel : Codable {
    let type:String?
    let data:String?
    let sender : String?
    let id : String?
    var reaction : Int?
}


struct GetSingleWidgetResponseModel : Codable {
    let success: Bool?
    let message:String?
    let data: WidgetFullData?
}

struct WidgetFullData : Codable {
    
    let name:String
    let members :[UserModel]
    let contents : ContentModel
    let creator:String
    let id:String
    
}


struct GetHistoryResponseModel: Codable {
    
    let success:Bool?
    let message:String?
    let data : [HistoryModel]?
    
}

struct HistoryModel : Codable {
    
    let showTime:String
    var data : [HistoryItemModel]
    
}


struct HistoryItemModel : Codable {
    let sender : UserModel
    let type:String
    let data:String // image url
    let reaction : Int
    let createdAt: String
    let id:String
}


struct ReactToContentResponseModel: Codable {
    
    let success:Bool?
    let message:String?
    
}

