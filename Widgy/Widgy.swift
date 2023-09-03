//
//  Widgy.swift
//  Widgy
//
//  Created by Javad on 9/3/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider<Intent:INIntent>: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", widgetModel: nil)
    }

    func getSnapshot(for configuration:Intent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", widgetModel: nil)
        completion(entry)
    }

    func getTimeline(for configuration:Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        
        
        let identifier :String?
        
        switch configuration {
        case let intent as MyWidgetIntentIntent:
            identifier = intent.LoveWidgetType?.identifier
        default: identifier = nil
        }
        
        var entries: [SimpleEntry] = []
        
        if let identifier = identifier {
            
            let widget = loadWidget(by: identifier)
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, emoji: "😀", widgetModel: widget)
                entries.append(entry)
            }
            
        } else {
            //show idle widget
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, emoji: "😀", widgetModel: nil)
                entries.append(entry)
            }
        }
        
        
        

        

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let widgetModel : WidgetServerModel?
}

struct WidgyEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        VStack {
            
            if let widget = entry.widgetModel {
                Text(widget.name!)
            } else {
                Text("Time:")
                Text(entry.date, style: .time)

                Text("Emoji:")
                Text(entry.emoji)
            }
            
        }
    }
}

typealias LoveWidgetProvider = Provider<MyWidgetIntentIntent>

struct Widgy: Widget {
    let kind: String = "Love Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: MyWidgetIntentIntent.self,
                            provider: LoveWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                WidgyEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgyEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Love Widget")
        .description("This is an Love Widget.")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}
