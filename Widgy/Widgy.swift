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
            Task {
                try? await WidgetNetworkManager().getHistoryForWidget(widgetId: identifier)
            }
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
                        
                        VStack {
                            HStack {
                                
                                Button(intent: UpdateWidgetIntent(widgetId: widget.id ?? "")) {
                                    VStack {
                                        Image("btnReload")
                                    }
                                }
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
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
                        }
                    }
                } else {
                    GeometryReader { proxy in
                        Image(.imgWidgetEmptyBg)
                            .resizable()
                    }
                    
                }
                
            } else {
                Image(.configureWidgetBg)
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
                    .containerBackground(Color(hex: "#87A2FB"), for: .widget)
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
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
