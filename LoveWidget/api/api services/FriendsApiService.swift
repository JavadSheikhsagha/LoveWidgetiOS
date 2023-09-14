//
//  FriendsApiService.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


protocol FriendsApiService {
    
    func addFriend(friendId: String,
                   onResponse: @escaping (DataState<DeleteFriendResponseModel?, ErrorType?, String?>) -> Void)
    func getFriends(onResponse: @escaping (DataState<GetFriendsResponseModel?, ErrorType?, String?>) -> Void)
    func deleteFriends(friendId: String,
                       onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void)
    
}

class FriendsApiService_Impl : FriendsApiService {
    
    
    func addFriend(friendId: String,
                   onResponse: @escaping (DataState<DeleteFriendResponseModel?, ErrorType?, String?>) -> Void) {
        
        let url = "\(base_url)/user/friends/add"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameters = ["friendCode": friendId]
        
        PatchApiService<DeleteFriendResponseModel>(parameters: parameters, header: header, url: url).fetch(onResponse: onResponse)
    }
    
    func getFriends(onResponse: @escaping (DataState<GetFriendsResponseModel?, ErrorType?, String?>) -> Void) {
        let url = "\(base_url)/user/friends/show"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<GetFriendsResponseModel>(url: url, header: header).fetch(onResponse: onResponse)
    }
    
    func deleteFriends(friendId: String,
                       onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void) {
        let url = "\(base_url)/user/friends/delete"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameter = ["friendId":friendId]
        
        DeleteApiService<DeleteUserResponseModel>(parameters: parameter, header: header, url: url)
            .fetch(onResponse: onResponse)
    }
    
    
    
}
