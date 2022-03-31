//
//  Reminder.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation
import DocumentID

public enum ReminderPriority: String, Codable, @unchecked Sendable {
    case none
    case high
    case medium
    case low
}

public struct Reminder: CalendarItem {

    @DocumentID public var id: String
    public var calendarID: Calendar.ID
    public var title: String
    @ExplicitNull public var color: RGB?
    @ExplicitNull public var location: String?
    @ExplicitNull public var timeZone: TimeZone?
    @ExplicitNull public var url: URL?
    @ExplicitNull public var notes: String?
    @ExplicitNull public var attendees: [Participant]?
    @ExplicitNull public var alarms: [Alarm]?
    @ExplicitNull public var recurrenceRules: [RecurrenceRule]?

    // Reminder
    public var priority: ReminderPriority
    @ExplicitNull public var startDateComponents: DateComponents?
    @ExplicitNull public var dueDateComponents: DateComponents?
    public var isCompleted: Bool
    @ExplicitNull public var completionDate: Date?


    public init(
        id: String,
        calendarID: Calendar.ID,
        title: String,
        color: RGB? = nil,
        location: String? = nil,
        timeZone: TimeZone? = nil,
        url: URL? = nil,
        notes: String? = nil,
        attendees: [Participant]? = nil,
        alarms: [Alarm]? = nil,
        recurrenceRules: [RecurrenceRule]? = nil,
        priority: ReminderPriority = .none,
        startDateComponents: DateComponents?,
        dueDateComponents: DateComponents?,
        isCompleted: Bool = false,
        completionDate: Date? = nil
    ) {
        self.id = id
        self.calendarID = calendarID
        self.title = title
        self.color = color
        self.location = location
        self.timeZone = timeZone
        self.url = url
        self.notes = notes
        self.attendees = attendees
        self.alarms = alarms
        self.recurrenceRules = recurrenceRules
        self.priority = priority
        self.startDateComponents = startDateComponents
        self.dueDateComponents = dueDateComponents
        self.isCompleted = isCompleted
        self.completionDate = completionDate
    }
}
