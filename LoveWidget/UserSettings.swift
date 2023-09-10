//
//  UserSettings.swift
//  LoveWidget
//
//  Created by Javad on 8/31/23.
//

import Foundation
import WidgetKit


var appSuitName = "group.pedram.widget"

func saveToken(token:String) {
    
    UserDefaults(suiteName: appSuitName)?.setValue(token, forKey: "token")
}

func getToken() -> String? {
    return UserDefaults(suiteName: appSuitName)?.string(forKey: "token")
}

func saveUser(userModel: UserModel?) {
    
    if let encoded = try? JSONEncoder().encode(userModel){
        UserDefaults(suiteName: appSuitName)!.setValue(encoded, forKey: "user")
    }
    
}


func loadUser() -> UserModel? {
    
    if let data = UserDefaults(suiteName: appSuitName)!.data(forKey: "user") {
        if let decoded = try? JSONDecoder().decode(UserModel.self, from: data) {
            return decoded
        }
    }
    return nil
}

func isUserGuest() -> Bool {
    if !(loadUser()?.isVerified ?? false) {
        return true
    } else {
        return false
    }
}

func saveEmail(email:String) {
    UserDefaults(suiteName: appSuitName)?.set(email, forKey: "email")
}

func loadEmail() -> String? {
    return UserDefaults(suiteName: appSuitName)?.string(forKey: "email")
}


func isUserLoggedIn() -> Bool {
    if loadUser()?.username.count ?? 0 > 0 {
        return true
    } else {
        return false
    }
}

func saveAllWidgetsToDatabase(widgets:[WidgetServerModel]) {
    if let encoded = try? JSONEncoder().encode(widgets) {
        UserDefaults(suiteName: appSuitName)?.set(encoded, forKey: "SavedWidgets")
    }
}

func loadWidgets() -> [WidgetServerModel]? {
    if let data = UserDefaults(suiteName: appSuitName)?.data(forKey: "SavedWidgets") {
        if let decoded = try? JSONDecoder().decode([WidgetServerModel].self, from: data) {
//
//            decoded.reverse()
            return decoded
        }
    }
    return nil
}

func loadWidget(by id : String) -> WidgetServerModel? {
    
    if let widgets = loadWidgets() {
        for i in widgets {
            if i.id == id {
                return i
            }
        }
    }
    return nil
}

func updateWidget(widget:WidgetFullData) -> Bool {
    
    var widgets = loadWidgets() ?? []
    for i in 0..<widgets.count {
        
        if widgets[i].id == widget.id {
            widgets[i] = WidgetServerModel(name: widget.name,
                                           creator: widget.creator,
                                           contents: widget.contents,
                                           reactions: [],
                                           id: widget.id)
            saveAllWidgetsToDatabase(widgets: widgets)
            return true
        }
        
    }
    return false
}

func updateWidgetReaction(widgetid:String) -> Bool {
    let widget = loadWidget(by: widgetid)!
    var widgets = loadWidgets() ?? []
    for i in 0..<widgets.count {
        
        if widgets[i].id == widget.id {
            widgets[i] = WidgetServerModel(name: widget.name,
                                           creator: widget.creator,
                                           contents: ContentModel(type: widget.contents?.type,
                                                                  data: widget.contents?.data,
                                                                  sender: widget.contents?.sender,
                                                                  id: widget.contents?.id,
                                                                  reaction: 1),
                                           reactions: [],
                                           id: widget.id)
            saveAllWidgetsToDatabase(widgets: widgets)
            return true
        }
        
    }
    return false
}
