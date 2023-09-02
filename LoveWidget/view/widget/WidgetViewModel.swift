//
//  WidgetViewModel.swift
//  LoveWidget
//
//  Created by Javad on 8/30/23.
//

import Foundation
import UIKit


class WidgetViewModel : ObservableObject {
    
    @Published var historyWidgets = [WidgetServerModel]()
    @Published var allWidgetsMain = [WidgetServerModel]()
    @Published var selectedWidgetModel : WidgetServerModel? = nil
    @Published var getSingleWidgetData : WidgetFullData? = nil
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isErrorOccurred = false
    
    @Published var selectedImage : UIImage? = nil
    
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
    
    func uploadImageToHistory(onSuccess: @escaping (Bool)-> Void) {
        
    }
    
    func getWidgets(onSuccess: @escaping (Bool) -> Void ) {
        
        let url = "\(base_url)/widget/home"
        let header = ["Authorization":"Bearer \(getToken() ?? "")"]
        
        if let widgets = loadWidgets() {
            self.allWidgetsMain = widgets
        }
        
        GetApiService<GetAllWidgetResponseModel>(url: url, header: header)
            .fetch { dataState in
                
                switch(dataState) {
                    
                case .success(data: let data, message: _):
                    if let data = data {
                        if data.success == true {
                            
                            if let d = data.data {
                                self.allWidgetsMain = d
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
    let contents:[ContentModel]?
    let reactions:[String]?
    let id:String?
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


struct ContentModel : Codable {
    let type:String
    let data:String
    let sender : String
    let reaction : Int
}


struct GetSingleWidgetResponseModel : Codable {
    let success: Bool?
    let message:String?
    let data: WidgetFullData?
}

struct WidgetFullData : Codable {
    
let name:String
    let members :[UserModel]
    let contents : [ContentModel]
    let creator:String
    let id:String
    
}
