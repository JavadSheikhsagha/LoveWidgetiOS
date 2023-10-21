//
//  WidgetApiService.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


protocol WidgetApiService {
    
    func sendMissYouNotif(widgetId:String,
                          onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func reactToContent(contentId:String, widgetId:String,
                        onResponse: @escaping (DataState<ReactToContentResponseModel? , ErrorType?, String?>) -> Void)
    func getHistoryList(widgetId:String, 
                        onResponse: @escaping (DataState<GetHistoryResponseModel?, ErrorType?, String?>) -> Void)
    func getSingleWidget(widgetId:String,
                         onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func addFriendToWidget(friendId: String,
                           widgetId:String,
                           onResponse: @escaping (DataState<AddFriendToWidgetResponse?, ErrorType?, String?>) -> Void)
    func getWidgets(onResponse: @escaping (DataState<GetAllWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func deleteWidget(widgetId:String,
                      onResponse: @escaping (DataState<DeleteWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func createWidget(name: String,
                      friendId: String?,
                      onSuccess: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func createWidgetWithMultipleFriends(widgetName:String,
                                         friendsIds:[String],
                                         onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void)
    func changeWidgetViewers(widgetId:String,
                             friendsIds:[String],
                             onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void)
}


class WidgetApiService_Impl : WidgetApiService {
    
    func changeWidgetViewers(widgetId: String,
                             friendsIds: [String],
                             onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/v2/add-users/\(widgetId)"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        var friendsIds1 = [String]()
        for i in friendsIds {
            friendsIds1.append(i)
        }
        let parameters = ["friendsIds":friendsIds1]
        
        PatchApiService<CreateWidgetResponseModel>(parameters: parameters, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    func createWidget(name: String,
                      friendId: String?,
                      onSuccess: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/create"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        var parameters = [
            "name":name
        ]
        if let friendId = friendId {
            parameters = [
                "name":name,
                "friendId":friendId
            ]
        }
        
        PostApiService<CreateWidgetResponseModel>(parameters: parameters, header: header, url: url)
            .fetch(onResponse: onSuccess)
        
    }
    
    func deleteWidget(widgetId: String,
                      onResponse: @escaping (DataState<DeleteWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/delete/\(widgetId)"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        DeleteApiService<DeleteWidgetResponseModel>(parameters: nil, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    func getWidgets(onResponse: @escaping (DataState<GetAllWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/home"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        GetApiService<GetAllWidgetResponseModel>(url: url, header: header)
            .fetch(onResponse: onResponse)
        
    }
    
    func addFriendToWidget(friendId: String,
                           widgetId:String,
                           onResponse: @escaping (DataState<AddFriendToWidgetResponse?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/add-user/\(widgetId)"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        let parameter = ["userId": friendId]
        
        PatchApiService<AddFriendToWidgetResponse>(parameters: parameter, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    func getSingleWidget(widgetId: String,
                         onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/single/\(widgetId)"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<GetSingleWidgetResponseModel>(url: url, header: header)
            .fetch (onResponse: onResponse)
        
    }
    
    func getHistoryList(widgetId:String,
                        onResponse: @escaping (DataState<GetHistoryResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/history/app/\(widgetId)"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<GetHistoryResponseModel>(url: url, header: header)
            .fetch(onResponse: onResponse)
        
    }
    
    func reactToContent(contentId: String,
                        widgetId: String,
                        onResponse: @escaping (DataState<ReactToContentResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/add-reaction/\(widgetId)/\(contentId)"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameter = ["type":"like"]
        
        PatchApiService<ReactToContentResponseModel>(parameters: parameter, header: header, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func sendMissYouNotif(widgetId:String,onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/miss-you/\(widgetId)"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        PostApiService<GetSingleWidgetResponseModel>(parameters: nil, header: header, url: url)
            .fetch(onResponse: onResponse)
    }
    
    func createWidgetWithMultipleFriends(widgetName:String,
                                         friendsIds:[String],
                                         onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/widget/v2/create"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        var ids : [String] = []
        
        for i in friendsIds {
            ids.append(i)
        }
        
        let parameters : [String:Any] = [
            "name":widgetName,
            "friendsIds":ids
        ]
        
        PostApiService<CreateWidgetResponseModel>(parameters: parameters, header: header, url: url)
            .fetch(onResponse: onResponse)
        
        
    }
    
    
    
}
