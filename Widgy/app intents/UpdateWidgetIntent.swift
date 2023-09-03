//
//  UpdateWidgetIntent.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation
import AppIntents

struct UpdateWidgetIntent : AppIntent {
    
    
    
    static var title: LocalizedStringResource = "Set Done Reminder"
    
    
    func perform() async throws -> some IntentResult {
        if let store = UserDefaults(suiteName: appSuitName) {
            
            let txt = await try? WidgetNetworkManager().getHistoryForWidget(widgetId: "")
            

            // save widget to database
            
            return .result()
        }
        return .result()
    }
    
}
