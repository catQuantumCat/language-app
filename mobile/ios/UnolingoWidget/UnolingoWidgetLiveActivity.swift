//
//  UnolingoWidgetLiveActivity.swift
//  UnolingoWidget
//
//  Created by Huy on 18/5/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct UnolingoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct UnolingoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UnolingoWidgetAttributes.self) { context in
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

extension UnolingoWidgetAttributes {
    fileprivate static var preview: UnolingoWidgetAttributes {
        UnolingoWidgetAttributes(name: "World")
    }
}

extension UnolingoWidgetAttributes.ContentState {
    fileprivate static var smiley: UnolingoWidgetAttributes.ContentState {
        UnolingoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: UnolingoWidgetAttributes.ContentState {
         UnolingoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: UnolingoWidgetAttributes.preview) {
   UnolingoWidgetLiveActivity()
} contentStates: {
    UnolingoWidgetAttributes.ContentState.smiley
    UnolingoWidgetAttributes.ContentState.starEyes
}
