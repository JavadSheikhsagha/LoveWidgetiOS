//
//  WidgetViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class WidgetViewModel : ObservableObject {
    
    @Published var historyWidgets = [HistoryModel]()
    @Published var allWidgetsMain = [WidgetServerModel]()
    @Published var selectedWidgetModel : WidgetServerModel? = nil
    @Published var getSingleWidgetData : WidgetFullData? = nil
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    @Published var selectedImage : UIImage? = nil
    @Published var isImageUplaoded = false
    
    
    func getSecondMember() -> UserModel? {
        
        for i in getSingleWidgetData?.members ?? [] {
            if i.id != loadUser()?.id {
                return i
            }
        }
        
        return nil
    }
    
    
    func reactToContent(contentId:String, widgetId:String, onSuccess: @escaping (Bool) -> Void) {
        let url = "\(base_url)/widget/add-reaction/\(widgetId)/\(contentId)"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        let parameter = ["type":"like"]
        
        PatchApiService<ReactToContentResponseModel>(parameters: parameter, header: header, url: url)
            .fetch { dataState in
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            self.getWidgets { bool in
                                onSuccess(true)
                            }
                            
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to get widget data.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to get widget data."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to get widget data.") ?? "Failed to get widget data."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
        
    }
    
    func getHistoryList(onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/widget/history/app/\(selectedWidgetModel?.id ?? "")"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<GetHistoryResponseModel>(url: url, header: header)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            if let history = data.data{
                                for i in 0..<self.historyWidgets.count {
                                    self.historyWidgets[i].data = self.historyWidgets[i].data.reversed()
                                }
                                self.historyWidgets = history.reversed()
                            }
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to get widget data.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to get widget data."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to get widget data.") ?? "Failed to get widget data."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
                
            }
    }
    
    func getSingleWidget(onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/widget/single/\(selectedWidgetModel?.id ?? "")"
        let header = ["Authorization": "Bearer \(getToken() ?? "")"]
        
        GetApiService<GetSingleWidgetResponseModel>(url: url, header: header)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            if let d = data.data {
                                self.getSingleWidgetData = d
                                print(d)
                                
                            }
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to get widget data.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to get widget data."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to get widget data.") ?? "Failed to get widget data."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
                
            }
    }
    
    func addFriendToWidget(friendId: String, onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/widget/add-user/\(selectedWidgetModel?.id ?? "")"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        let parameter = ["userId": friendId]
        
        PatchApiService<AddFriendToWidgetResponse>(parameters: parameter, header: header, url: url)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            
                            self.getWidgets { bool in
                                onSuccess(true)
                            }
                            
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to get widgets.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to get widgets."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to get widgets.") ?? "Failed to get widgets."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
        
    }
    
    func uploadImageToHistory(image : UIImage?, onResponse : @escaping (Bool) -> Void) {
        
        if let image1 = image?.jpegData(compressionQuality: 1.0) {
            
            let link = "\(base_url)/widget/add-content/\(selectedWidgetModel?.id ?? "")"
            
            
            print(link)
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data",
                "Authorization" : "Bearer \(getToken() ?? "")"
            ]
            
            print(headers)
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(image1, withName: "image", fileName: "img123.jpg", mimeType: "image/jpeg")
                multipartFormData.append("text".data(using: .utf8)!, withName: "type")
            },to: link , method: .post , headers: headers)
                .uploadProgress(closure: { progress in
                    print("upload \(progress)")
                }).downloadProgress(closure: { progress in
                    print("download \(progress)")
                })
                .validate()
                .responseJSON(completionHandler: { response in
                    print(JSON(response.data))
                    switch response.result{
                        case .success(let value):
                            print(JSON(value))
                        
//                        if let data = response.data {
//                            let decoded = MyDecoder<CreateWidgetResponseModel>().decodeJSON(json: data)
//                            switch decoded {
//                                case .success(_):
//                                self.getSingleWidget { bol in }
//                                    break
//                                case .failure(let error):
//                                self.isErrorOccurred = true
//                                self.isLoading = false
//                                self.errorMessage = (error?.localizedDescription ?? "Failed to get widgets.") 
//                                    break
//                            }
//                        }
//                        
                            
                            onResponse(true)
                            
                            break
                        case .failure(let error):
                        onResponse(false)
                        
                        self.isErrorOccurred = true
                        self.isLoading = false
                        self.errorMessage = (error.localizedDescription ) 
                                            
                    }
                   
                })
            
        }
    }
    
    func getWidgets(onSuccess: @escaping (Bool) -> Void ) {
        
        let url = "\(base_url)/widget/home"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        if let widgets = loadWidgets() {
            self.allWidgetsMain = widgets.reversed()
        }
        
        GetApiService<GetAllWidgetResponseModel>(url: url, header: header)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            if let d = data.data {
                                self.allWidgetsMain = d.reversed()
                                saveAllWidgetsToDatabase(widgets: d)
                            }
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to get widgets.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to get widgets."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to get widgets.") ?? "Failed to get widgets."
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
                
            }
        
    }
    
    func deleteWidget(onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/widget/delete/\(selectedWidgetModel?.id ?? "")"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        DeleteApiService<DeleteWidgetResponseModel>(parameters: nil, header: header, url: url)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            self.selectedWidgetModel = nil
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to delete widget.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to delete widget."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to delete widget.") ?? "Failed to delete widget."
                    
                    
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
    }
    
    func createWidget(name: String, friendId: String?, onSuccess: @escaping (Bool) -> Void) {
        
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
            .fetch { dataState in
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            self.selectedWidgetModel = data.data
                            onSuccess(true)
                        } else {
                            self.isErrorOccurred = true
                            self.errorMessage = data.message ?? "Failed to create widget.."
                            onSuccess(false)
                        }
                        
                    } else {
                        self.isErrorOccurred = true
                        
                        self.errorMessage = "failed to create widget."
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: let msg):
                    self.isErrorOccurred = true
                    self.isLoading = false
                    self.errorMessage = (msg ?? "Failed to create widget.") ?? "Failed to create widget."
                    
                    
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
//    "message": "widget created successfully",
//    "data": {
//        "name": "new widget",
//        "creator": "64f2c823ce210fdecd128775",
//        "contents": [],
//        "reactions": [],
//        "id": "64f2c89ace210fdecd128782"
//    }
//}
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

//{
//    "success": true,
//    "message": "widget history",
//    "data": [
//        {
//            "id": "64f2feb852be8d120932d07d",
//            "name": "Asdasd",
//            "contents": []
//        },
//        {
//            "id": "64f2fec152be8d120932d083",
//            "name": "Wid2",
//            "contents": []
//        }
//    ]
//}

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

