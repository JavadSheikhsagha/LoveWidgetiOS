//
//  IntentHandler.swift
//  WidgetEditIntent
//
//  Created by Javad on 9/3/23.
//

import Intents

class IntentHandler: INExtension {
    
    
    private func objectCollection(for intent:INIntent) -> INObjectCollection<LoveWidgetTypeModel>? {
        
        let widgets = loadWidgets()
        
        var options : [LoveWidgetTypeModel] = []
        
        if let widgets = widgets {
            
            
            for i in widgets {
                
                options.append(LoveWidgetTypeModel(identifier: i.id, display: i.name ?? "widget#"))
            }
            
        } else {
            
            
            options.append(LoveWidgetTypeModel(identifier: "iden1", display: "disp1"))
            options.append(LoveWidgetTypeModel(identifier: "iden2", display: "disp2"))
        }
        
//
        
        
        
        
        
        return INObjectCollection(items: options)
    }
    
}


extension IntentHandler : MyWidgetIntentIntentHandling {
    

//    
//    func provideLoveWidgetTypeOptionsCollection(for intent: MyWidgetIntentIntent) async throws -> INObjectCollection<LoveWidgetTypeModel> {
//        return objectCollection(for: intent)!
//    }
    
//    
//    func provideWidgetEditModelOptionsCollection(
//        for intent: MyWidgetIntentIntent,
//        with completion: @escaping (INObjectCollection<LoveWidgetTypeModel>?, Error?) -> Void) {
//
//            completion(objectCollection(for: intent), nil)
//    }
    
    func provideLoveWidgetTypeOptionsCollection(for intent: MyWidgetIntentIntent, with completion: @escaping (INObjectCollection<LoveWidgetTypeModel>?, Error?) -> Void) {
        completion(objectCollection(for: intent), nil)
    }
    
}
