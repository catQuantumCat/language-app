//
//  UnolingoWidgetBundle.swift
//  UnolingoWidget
//
//  Created by Huy on 18/5/25.
//

import WidgetKit
import SwiftUI

@main
struct UnolingoWidgetBundle: WidgetBundle {
    var body: some Widget {
        UnolingoWidget()
        UnolingoWidgetControl()
        UnolingoWidgetLiveActivity()
    }
}
