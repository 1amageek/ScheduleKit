//
//  Event.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import DocumentID
import RecurrenceRule
import SwiftColor

public enum EventStatus: String, Codable, @unchecked Sendable {
    case none
    case confirmed
    case tentative
    case canceled
}

public enum EventAvailability: String, Codable, @unchecked Sendable {
    case notSupported
    case busy
    case free
    case tentative
    case unavailable
}

public struct Event: CalendarItem {

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

    // Event
    public var status: EventStatus
    public var availability: EventAvailability
    public var occurrenceDate: Date
    public var isAllDay: Bool
    public var startDate: Date
    public var endDate: Date
    @ExplicitNull public var structuredLocation: StructuredLocation?
    @ExplicitNull public var organizer: Participant?

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
        status: EventStatus = .none,
        availability: EventAvailability = .notSupported,
        occurrenceDate: Date,
        isAllDay: Bool,
        startDate: Date,
        endDate: Date,
        structuredLocation: StructuredLocation? = nil,
        organizer: Participant? = nil
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
        self.status = status
        self.availability = availability
        self.occurrenceDate = occurrenceDate
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.structuredLocation = structuredLocation
        self.organizer = organizer
    }
}
