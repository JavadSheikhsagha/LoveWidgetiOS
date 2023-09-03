//
//  WidgetNetworkManager.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation

class WidgetNetworkManager {
    
    func getHistoryForWidget(widgetId:String) async throws -> WidgetFullData? {
        
        let url = URL(string: "\(base_url)/widget/history/widget/\(widgetId)")!
//        var request = URLRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try? JSONDecoder().decode(GetSingleWidgetResponseModel.self, from: data)
        
        print(decoded ?? "")
        
        return decoded?.data
    }
    
    func reactToContent(widgetId:String, contentId:String) async throws -> Bool? {
        
        let url = URL(string: "\(base_url)/widget/add-reaction/\(widgetId)/\(contentId)")!
        var request = URLRequest(url: url)
        
        request.setValue(
            "Bearer \(getToken() ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let body = ["type": "like"]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        request.httpMethod = "PATCH"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in

            if let error = error {
                // Handle HTTP request error
            } else if let data = data {
                // Handle HTTP request response
            } else {
                // Handle unexpected error
            }
        }
        task.resume()
        
        return nil
    }
    
    
    
    static func fetchRandomDog() async throws -> String {
        
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        
        print(data.count)
        
        return String(data.count) ?? "hl"
    }
    
}

