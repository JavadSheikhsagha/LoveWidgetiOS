//
//  Widgy.swift
//  Widgy
//
//  Created by Javad on 9/3/23.
//

import WidgetKit
import SwiftUI
import Intents
import AppIntents

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
            for hourOffset in 0 ..< 100 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, emoji: "😀", widgetModel: widget)
                entries.append(entry)
            }
            
        } else {
            //show idle widget
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 100 {
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
        ZStack {
            
            if let widget = entry.widgetModel  {
                
                if widget.contents?.data != nil {
//                    NetworkImage(url: URL(string: "https://i.stack.imgur.com/Tq8IR.png"))
                    ZStack(alignment:.bottomTrailing) {
                        GeometryReader { proxy in
                            NetworkImage(url: URL(string: widget.contents!.data ?? "imageUrl"))
                                .frame(width: proxy.frame(in: .local).width, height: proxy.frame(in: .local).height)
                        }
                        
                        Button(intent: ReactToWidgetIntent(widgetId: widget.id ?? "",
                                                           contentId: widget.contents?.id ?? "")) {
                            VStack {
                                if widget.contents?.reaction ?? 0 > 0 {
                                    Image(.imgLikeFilled)
                                } else {
                                    Image(.imgLikeBorder)
                                }
                            }
                        }
                    }
                } else {
                    Text("No Image Added yet.")
                        .multilineTextAlignment(.center)
                }
                
            } else {
                Text("Please set your widget to show.")
            }
            
            
        }
    }
}

struct ReactToWidgetIntent : AppIntent {
    // watch the video for how to pass data to intent
    static var title: LocalizedStringResource = "React to widget"


    @Parameter(title: "widgetId")
    var widgetId:String


    @Parameter(title: "ContentId")
    var contentId:String


    init() { }

    init(widgetId: String, contentId: String) {
        self.widgetId = widgetId
        self.contentId = contentId
    }


    func perform() async throws -> some IntentResult {
        if UserDefaults(suiteName: appSuitName) != nil {
            
            _ = try? await WidgetNetworkManager().reactToContent(widgetId: widgetId, contentId: contentId)

            _ = try? await WidgetNetworkManager().getHistoryForWidget(widgetId: widgetId)

            return .result()
        }
        return .result()
    }

}

struct UpdateWidgetIntent : AppIntent {
    
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")
    
    
    @Parameter(title: "widgetId")
    var widgetId:String
    
    
    init() {
        
    }
    
    init(widgetId: String) {
        self.widgetId = widgetId
        print(widgetId)
    }
    
    func perform() async throws -> some IntentResult {
        if UserDefaults(suiteName: appSuitName) != nil {
            
            _ = try? await WidgetNetworkManager().getHistoryForWidget(widgetId: widgetId)
            

            // save widget to database
            
            return .result()
        }
        return .result()
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


struct NetworkImage: View {

  let url: URL?

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
         .aspectRatio(contentMode: .fill)
      }
      else {
          VStack {
              Image(.imgUserSample)
              Text("Loading..")
                  .font(.system(size: 13))
          }
      }
    }
  }

}
