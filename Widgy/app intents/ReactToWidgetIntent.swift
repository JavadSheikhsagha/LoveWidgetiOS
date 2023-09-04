//
//  ReactToWidgetIntent.swift
//  LoveWidget
//
//  Created by Javad on 9/3/23.
//

import Foundation
import AppIntents


//struct ReactToWidgetIntent : AppIntent {
//    // watch the video for how to pass data to intent
//    static var title: LocalizedStringResource = "React to widget"
//    
//    
//    @Parameter(title: "widgetId")
//    var widgetId:String
//    
//    
//    @Parameter(title: "ContentId")
//    var contentId:String
//    
//    
//    init() {
//        
//    }
//
//    init(widgetId: String, contentId: String) {
//        self.widgetId = widgetId
//        self.contentId = contentId
//    }
//    
//    
//    func perform() async throws -> some IntentResult {
//        if UserDefaults(suiteName: appSuitName) != nil {
//            
//            _ = try? await WidgetNetworkManager().reactToContent(widgetId: widgetId, contentId: contentId)
//            
//            _ = try? await WidgetNetworkManager().getHistoryForWidget(widgetId: widgetId)
//            
//            return .result()
//        }
//        return .result()
//    }
//    
//}
