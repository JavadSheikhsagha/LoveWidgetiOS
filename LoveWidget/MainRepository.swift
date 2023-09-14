//
//  MainRepository.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


class MainRepository : MainApiService {
    
    private var mainApiServiceImpl = MainApiService_impl()
    
    
    
    
    func deleteUser(onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void) {
        mainApiServiceImpl.deleteUser(onResponse: onResponse)
    }
    
    func changeUsername(newUsername: String, onResponse: @escaping (DataState<ChangeUsernameResponseModel?, ErrorType?, String?>) -> Void) {
        mainApiServiceImpl.changeUsername(newUsername: newUsername, onResponse: onResponse)
    }
    
    
}
