//
//  PlantWidgetBundle.swift
//  PlantWidget
//
//  Created by Rishika Kundu on 3/25/25.
//

import WidgetKit
import SwiftUI

@main
struct PlantWidgetBundle: WidgetBundle {
    var body: some Widget {
        PlantWidget()
        PlantWidgetControl()
        PlantWidgetLiveActivity()
    }
}
