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
    
    private let widgetRepository = WidgetRepository()
    
    
    @Published var historyWidgets = [HistoryModel]()
    @Published var allWidgetsMain = [WidgetServerModel]()
    @Published var selectedWidgetModel : WidgetServerModel? = nil
    @Published var getSingleWidgetData : WidgetFullData? = nil
    @Published var selectedImageForBigView : WidgetServerModel? = nil
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    @Published var selectedImage : UIImage? = nil
    @Published var isImageUplaoded = false
    
    func sendMissYouNotif(onSuccess: @escaping (Bool) -> Void) {
        
        widgetRepository.sendMissYouNotif(widgetId: selectedWidgetModel?.id ?? "") { dataState in
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            onSuccess(true)
                        } else {
                            onSuccess(false)
                        }
                        
                    } else {
                        onSuccess(false)
                    }
                    self.isLoading = false
                    
                case .error(error: _, message: _):
                    onSuccess(false)
                case .loading(message: _):
                    self.isLoading = true
                    self.isErrorOccurred = false
                    self.errorMessage = ""
                    
                case .idle(message: _):
                    break
                }
            }
    }
    
    func getSecondMember() -> UserModel? {
        
        for i in getSingleWidgetData?.members ?? [] {
            if i.id != loadUser()?.id {
                return i
            }
        }
        
        return nil
    }
    
    
    func reactToContent(contentId:String, widgetId:String, onSuccess: @escaping (Bool) -> Void) {
        
        widgetRepository.reactToContent(contentId: contentId, widgetId: widgetId) { dataState in
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
        
        widgetRepository.getHistoryList(widgetId: self.selectedWidgetModel?.id ?? "") { dataState in
                
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
        
        widgetRepository.getSingleWidget(widgetId: self.selectedWidgetModel?.id ?? "") { dataState in
                
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
        
        widgetRepository.addFriendToWidget(friendId: friendId, widgetId: self.selectedWidgetModel?.id ?? "") { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            
                            self.getWidgets { bool in
                                onSuccess(true)
                            }
                            self.getSingleWidget { bool in
                                
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
        
        self.widgetRepository.getWidgets { dataState in
                
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
        
        widgetRepository.deleteWidget(widgetId: self.selectedWidgetModel?.id ?? ""){ dataState in
                
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
        
        widgetRepository.createWidget(name: name, friendId: friendId) { dataState in
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


