//
//  FriendsViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import Foundation


class FriendsViewModel : ObservableObject {
    
    private let friendsRepository = FriendsRepository()
    
    
    @Published var friends = [UserModel]()
    @Published var selectedFriends : [UserModel] = []
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    
    
    func addFriend(friendId: String, onSuccess: @escaping (Bool) -> Void) {
        
        friendsRepository.addFriend(friendId: friendId) { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                if let data = data {
                    if data.success == true {
                        self.getFriends { bool in
                            onSuccess(bool)
                        }
                    } else {
                        self.isErrorOccurred = true
                        self.errorMessage = data.message ?? "Failed to add friend.."
                        onSuccess(false)
                    }
                    
                } else {
                    self.isErrorOccurred = true
                    
                    self.errorMessage = "failed to add friend."
                    onSuccess(false)
                }
                self.isLoading = false
                
            case .error(error: _, message: let msg):
                self.isErrorOccurred = true
                self.isLoading = false
                self.errorMessage = (msg ?? "Failed to add friend.") ?? "Failed to add friend."
                
                
            case .loading(message: _):
                self.isLoading = true
                self.isErrorOccurred = false
                self.errorMessage = ""
                
            case .idle(message: _):
                break
            }
        }
    }
    
    func getFriends(onSuccess: @escaping (Bool) -> Void) {
        
        friendsRepository.getFriends { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                if let data = data {
                    if data.success == true {
                        self.friends = data.data ?? []
                        onSuccess(true)
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = data.message ?? "Failed to get friend list."
                        onSuccess(false)
                    }
                    
                } else {
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = "failed to get friends."
                    onSuccess(false)
                }
                self.isLoading = false
                
            case .error(error: _, message: let msg):
                self.isErrorOccurred = true
                self.isLoading = false
                self.errorMessage = (msg ?? "Failed to retrieve friend list.") ?? "Failed to retrieve friend list."
                
                
            case .loading(message: _):
                self.isLoading = true
                self.isErrorOccurred = false
                self.errorMessage = ""
                
            case .idle(message: _):
                break
            }
        }
    }
    
    func deleteFriend(friendId: String, onSuccess : @escaping (Bool) -> Void) {
        
        friendsRepository.deleteFriends(friendId: friendId) { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                if let data = data {
                    if data.success == true {
                        self.getFriends { bool in
                            onSuccess(bool)
                        }
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = data.message
                        onSuccess(false)
                    }
                    
                } else {
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = "failed to delete friend."
                    onSuccess(false)
                }
                self.isLoading = false
                
            case .error(error: _, message: let msg):
                self.isErrorOccurred = true
                self.isLoading = false
                self.errorMessage = (msg ?? "Failed to delete friend from your friend list.") ?? "Failed to delete friend from your friend list."
                
                
            case .loading(message: _):
                self.isLoading = true
                self.isErrorOccurred = false
                self.errorMessage = ""
                
            case .idle(message: _):
                break
            }
        }
        
    }
    
}
