//
//  MainApiService.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation

protocol MainApiService {
    
    func deleteUser(onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void)
    func changeUsername(newUsername:String,
                        onResponse: @escaping (DataState<ChangeUsernameResponseModel?, ErrorType?, String?>) -> Void)
    func notifyFriends(onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void)
    
}


class MainApiService_impl : MainApiService {
    
    func notifyFriends(onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void) {
        let url =  "\(base_url)/widget/v2/notify-friends"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<DeleteUserResponseModel>(url: url, header: header)
            .fetch(onResponse: onResponse)
    }
    
    func deleteUser(onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void) {
        let url =  "\(base_url)/auth/delete-account"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        DeleteApiService<DeleteUserResponseModel>(parameters: nil, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    func changeUsername(newUsername:String,
                        onResponse: @escaping (DataState<ChangeUsernameResponseModel?, ErrorType?, String?>) -> Void) {
        let url =  "\(base_url)/user/edit-username"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameters = ["username": newUsername]
        
        PatchApiService<ChangeUsernameResponseModel>(parameters: parameters, header: header, url: url)
            .fetch(onResponse: onResponse)
        
    }
    
    
}
