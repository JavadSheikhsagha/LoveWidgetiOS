//
//  FriendsViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import Foundation


class FriendsViewModel : ObservableObject {
    
    
    @Published var friends = [UserModel]()
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    
    func addFriend(friendId: String, onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/user/friends/add"
        
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameters = ["friendCode": friendId]
        
        PatchApiService<DeleteFriendResponseModel>(parameters: parameters, header: header, url: url).fetch { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                if let data = data {
                    if data.success == true {
                        self.getFriends { bool in
                            onSuccess(bool)
                        }
                    } else {
                        self.isErrorOccurred = true
                        self.errorMessage = "Failed to add Friend.."
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
        
        let url = "\(base_url)/user/friends/show"
        
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        GetApiService<GetFriendsResponseModel>(url: url, header: header).fetch { dataState in
            switch(dataState) {
                
            case .success(data: let data, message: _):
                if let data = data {
                    if data.success == true {
                        self.friends = data.data ?? []
                        onSuccess(true)
                    } else {
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = "Failed to get Friends.."
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
        
        let url = "\(base_url)/user/friends/delete"
        
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameter = ["friendId":friendId]
        DeleteApiService<DeleteUserResponseModel>(parameters: parameter, header: header, url: url).fetch { dataState in
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
                        self.errorMessage = "Failed to Delete Friend.."
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


//{
//    "success": true,
//    "message": "user successfully added to friends",
//    "data": [
//        {
//            "username": "guest-1693484574003",
//            "profileImage": "http://157.90.30.203/widget-ios/userprofile/logo3.svg",
//            "id": "64f0861e9300ee5453f250ee"
//        }
//    ]
//}
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

