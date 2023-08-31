//
//  UserSettings.swift
//  LoveWidget
//
//  Created by Javad on 8/31/23.
//

import Foundation


var appSuitName = "app.love"

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
    if loadUser()?.username.contains("guest-") ?? true {
        return true
    } else {
        return false
    }
}


func isUserLoggedIn() -> Bool {
    if loadUser()?.username.count ?? 0 > 0 {
        return true
    } else {
        return false
    }
}
