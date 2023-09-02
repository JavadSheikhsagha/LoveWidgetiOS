//
//  WidgetViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import Foundation


class WidgetViewModel : ObservableObject {
    
    @Published var historyWidgets = [WidgetServerModel]()
    @Published var selectedWidgetModel : WidgetServerModel? = nil
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    func deleteWidget(onSuccess: @escaping (Bool) -> Void) {
        
        let url = "\(base_url)/widget/delete/\(selectedWidgetModel?.id ?? "")"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        DeleteApiService<CreateWidgetResponseModel>(parameters: nil, header: header, url: url)
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
    let contents:[String]?
    let reactions:[String]?
    let id:String?
}
