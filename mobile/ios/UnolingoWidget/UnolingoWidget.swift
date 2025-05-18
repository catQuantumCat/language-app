//
//  UnolingoWidget.swift
//  UnolingoWidget
//
//  Created by Huy on 18/5/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    private func getDataFromFlutter() -> SimpleEntry{
        
        let userDefault = UserDefaults(suiteName: "group.unolingo.widget")
        let textFromFlutterApp = userDefault?.string(forKey: "key_from_flutter_app")
        let intent = ConfigurationAppIntent()
        intent.currentStreak = textFromFlutterApp ?? "No data available"
        
        return SimpleEntry(date: Date(), configuration: intent)
    }
    //Placeholder
    
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        let entry = getDataFromFlutter()
        return Timeline(entries: [entry], policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}


//Data structure
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct UnolingoWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            // Background gradient - filling entire widget
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "58CC02"), Color(hex: "42A500")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 2) {
                // Top section with app name and icon
                HStack(alignment: .center) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("UNOLINGO")
                        .font(.system(size: 13, weight: .bold))
                        .kerning(0.5)
                        .foregroundColor(.white)
                }
                .padding(.top, 8)
                
                
                Text(entry.configuration.currentStreak + "XP")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.vertical, 0)
                
                // Streak label
                HStack(spacing: 3) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("EXPERIENCE")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 6)
                
                // Last updated time in subtle format
                Text("Updated: \(formattedTime(entry.date))")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 4)
            }
        }
    }
    
    // Helper function to format time
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}


//Widget
struct UnolingoWidget: Widget {
    let kind: String = "UnolingoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            UnolingoWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                                   
                                   Color.clear
                               }
            
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.currentStreak = "😀"
        
        
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.currentStreak = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    UnolingoWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
