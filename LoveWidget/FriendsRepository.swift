//
//  FriendsRepository.swift
//  LoveWidget
//
//  Created by Javad on 9/14/23.
//

import Foundation


class FriendsRepository : FriendsApiService {
    
    
    private let friendsApiService = FriendsApiService_Impl()
    
    
    func addFriend(friendId: String, onResponse: @escaping (DataState<DeleteFriendResponseModel?, ErrorType?, String?>) -> Void) {
        friendsApiService.addFriend(friendId: friendId, onResponse: onResponse)
    }
    
    func getFriends(onResponse: @escaping (DataState<GetFriendsResponseModel?, ErrorType?, String?>) -> Void) {
        friendsApiService.getFriends(onResponse: onResponse)
    }
    
    func deleteFriends(friendId: String, onResponse: @escaping (DataState<DeleteUserResponseModel?, ErrorType?, String?>) -> Void) {
        friendsApiService.deleteFriends(friendId: friendId, onResponse: onResponse)
    }
    
    
}
