//
//  PlantWidgetLiveActivity.swift
//  PlantWidget
//
//  Created by Rishika Kundu on 3/25/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PlantWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PlantWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PlantWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PlantWidgetAttributes {
    fileprivate static var preview: PlantWidgetAttributes {
        PlantWidgetAttributes(name: "World")
    }
}

extension PlantWidgetAttributes.ContentState {
    fileprivate static var smiley: PlantWidgetAttributes.ContentState {
        PlantWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PlantWidgetAttributes.ContentState {
         PlantWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PlantWidgetAttributes.preview) {
   PlantWidgetLiveActivity()
} contentStates: {
    PlantWidgetAttributes.ContentState.smiley
    PlantWidgetAttributes.ContentState.starEyes
}
