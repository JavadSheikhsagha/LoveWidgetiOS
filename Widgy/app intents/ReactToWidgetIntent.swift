//
//  ReactToWidgetIntent.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation
import AppIntents


struct ReactToWidgetIntent : AppIntent {
    
    // watch the video for how to pass data to intent
    
    static var title: LocalizedStringResource = "Set Done Reminder"
    
    
    func perform() async throws -> some IntentResult {
        if let store = UserDefaults(suiteName: appSuitName) {
            
            let txt = await try? WidgetNetworkManager().reactToContent(widgetId: "", contentId: "")
            
            
            if let txt = txt {
                store.setValue(txt, forKey: "prt")
            }
            
            return .result()
        }
        return .result()
    }
    
}
