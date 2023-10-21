//
//  WidgetRepository.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


class WidgetRepository : WidgetApiService {
    
    
    private let widgetApiService : WidgetApiService = WidgetApiService_Impl()
    
    
    func changeWidgetViewers(widgetId: String, 
                             friendsIds: [String],
                             onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.changeWidgetViewers(widgetId: widgetId, friendsIds: friendsIds, onResponse: onResponse)
    }
    
    func createWidgetWithMultipleFriends(widgetName:String,
                                         friendsIds:[String],
                                         onResponse: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.createWidgetWithMultipleFriends(widgetName: widgetName, friendsIds: friendsIds, onResponse: onResponse)
    }
    
    func sendMissYouNotif(widgetId: String, onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.sendMissYouNotif(widgetId: widgetId, onResponse: onResponse)
    }
    
    func reactToContent(contentId: String, widgetId: String, onResponse: @escaping (DataState<ReactToContentResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.reactToContent(contentId: contentId, widgetId: widgetId, onResponse: onResponse)
    }
    
    func getHistoryList(widgetId: String, onResponse: @escaping (DataState<GetHistoryResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.getHistoryList(widgetId: widgetId, onResponse: onResponse)
    }
    
    func getSingleWidget(widgetId: String, onResponse: @escaping (DataState<GetSingleWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.getSingleWidget(widgetId: widgetId, onResponse: onResponse)
    }
    
    func addFriendToWidget(friendId: String, widgetId: String, onResponse: @escaping (DataState<AddFriendToWidgetResponse?, ErrorType?, String?>) -> Void) {
        widgetApiService.addFriendToWidget(friendId: friendId, widgetId: widgetId, onResponse: onResponse)
    }
    
    func getWidgets(onResponse: @escaping (DataState<GetAllWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.getWidgets(onResponse: onResponse)
    }
    
    func deleteWidget(widgetId: String, onResponse: @escaping (DataState<DeleteWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.deleteWidget(widgetId: widgetId, onResponse: onResponse)
    }
    
    func createWidget(name: String, friendId: String?, onSuccess: @escaping (DataState<CreateWidgetResponseModel?, ErrorType?, String?>) -> Void) {
        widgetApiService.createWidget(name: name, friendId: friendId, onSuccess: onSuccess)
    }
    
    
    
}
