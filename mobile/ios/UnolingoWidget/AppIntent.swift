//
//  AppIntent.swift
//  UnolingoWidget
//
//  Created by Huy on 18/5/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    
    @Parameter(title: "Current streak", default: "No data available")
    var currentStreak: String
}
