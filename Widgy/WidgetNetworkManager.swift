//
//  WidgetNetworkManager.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation

class WidgetNetworkManager {
    
    func getHistoryForWidget(widgetId:String) async throws -> WidgetFullData? {
        
        let url = URL(string: "\(base_url)/widget/single/\(widgetId)")!
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(getToken() ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoded = try? JSONDecoder().decode(GetSingleWidgetResponseModel.self, from: data)
        print(decoded ?? "")
        
        if let data = decoded?.data {
            _ = updateWidget(widget: data)
            
        }
        
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

        let task = try? await session.data(for: request)
        
        
        return nil
    }
    
    
}

