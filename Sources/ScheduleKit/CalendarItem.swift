//
//  CalendarItem.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
@_exported import RecurrenceRule
@_exported import SwiftColor

public protocol CalendarItem: Identifiable, Hashable, Codable {
    var id: String { get }
    var calendarID: String { get }
    var title: String { get }
    var color: RGB { get }
    var location: String? { get }
    var timeZone: TimeZone? { get }
    var url: URL? { get }
    var notes: String? { get }
    var attendees: [Participant]? { get }
    var alarms: [Alarm]? { get }
    var recurrenceRules: [RecurrenceRule]? { get }
}
