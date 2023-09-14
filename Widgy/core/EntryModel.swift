//
//  EntryModel.swift
//  WidgyExtension
//
//  Created by Javad on 9/14/23.
//

import Foundation
import WidgetKit


struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let widgetModel : WidgetServerModel?
}
