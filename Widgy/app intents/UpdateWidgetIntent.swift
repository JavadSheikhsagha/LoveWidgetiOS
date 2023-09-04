//
//  UpdateWidgetIntent.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation
import AppIntents

//struct UpdateWidgetIntent : AppIntent {
//    
//    static var title: LocalizedStringResource = "Configuration"
//    static var description = IntentDescription("This is an example widget.")
//    
//    
//    @Parameter(title: "widgetId")
//    var widgetId:String
//    
//    
//    init() {
//        
//    }
//    
//    init(widgetId: String) {
//        self.widgetId = widgetId
//        print(widgetId)
//    }
//    
//    func perform() async throws -> some IntentResult {
//        if UserDefaults(suiteName: appSuitName) != nil {
//            
//            _ = try? await WidgetNetworkManager().getHistoryForWidget(widgetId: "")
//            
//
//            // save widget to database
//            
//            return .result()
//        }
//        return .result()
//    }
//    
//}



struct SetDoneReminderIntent : AppIntent {
    static var title: LocalizedStringResource = "Set Done Reminder"
    
    
    func perform() async throws -> some IntentResult {
        if let store = UserDefaults(suiteName: appSuitName) {
            
            
            return .result()
        }
        return .result()
    }
    
}
