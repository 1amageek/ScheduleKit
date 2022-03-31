//
//  CalendarModel.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation
import TrackEditor
import SwiftColor


public class CalendarModel: ObservableObject {

    public var calendar: Foundation.Calendar = .init(identifier: .iso8601)

    public var timeZone: TimeZone = .autoupdatingCurrent

    public var options: TrackEditorOptions = TrackEditorOptions(interval: .minute(30), headerWidth: 120, trackHeight: 70, barWidth: 80)

    @Published public var calendars: [Calendar]

    @Published public var events: [Event] {
        didSet {
            self.data = Dictionary(grouping: events, by: { $0.calendarID })
        }
    }

    public var defaultCalendar: Calendar?

    public var data: [String: [Event]] = [:]

    public var calendarStore: CalendarStore?

    public var eventStore: EventStore?

    public init(calendars: [Calendar] = [], events: [Event] = [], calendarStore: CalendarStore? = nil, eventStore: EventStore? = nil) {
        self.calendars = calendars
        self.events = events
        self.calendarStore = calendarStore
        self.eventStore = eventStore
    }

    var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter: DateComponentsFormatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    public func dateComponents(_ index: Int) -> DateComponents {
        switch options.interval {
            case .hour(let int):
                let hour = int * index
                return DateComponents(calendar: calendar, timeZone: timeZone, hour: hour)
            case .minute(let int):
                let time = int * index
                let (hour, minute) = time.quotientAndRemainder(dividingBy: 60)
                return DateComponents(calendar: calendar, timeZone: timeZone, hour: hour, minute: minute)
            case .second(let int):
                let time = int * index
                let (hour, minuteRemainder) = time.quotientAndRemainder(dividingBy: 3600)
                let (minute, second) = minuteRemainder.quotientAndRemainder(dividingBy: 60)
                return DateComponents(calendar: calendar, timeZone: timeZone, hour: hour, minute: minute, second: second)
        }
    }

    public func label(_ index: Int) -> String {
        let dateComponents = dateComponents(index)
        return dateComponentsFormatter.string(from: dateComponents)!
    }

    // Calendar: -

    public func fetchCalendars<Response>() -> AsyncThrowingStream<([Calendar], Response), Error>? {
        calendarStore?.fetchCalendars()
    }

    public func update(calendar: Calendar) async throws {
        try await calendarStore?.update(calendar: calendar)
        if calendars.contains(where: { $0.id == calendar.id }) {
            Task.detached {
                self.calendars[calendar.id] = calendar
            }
        } else {
            calendars.append(calendar)
        }
    }

    public func delete(calendar: Calendar) async throws {
        try await calendarStore?.delete(calendar: calendar)
        Task.detached {
            self.calendars[calendar.id] = nil
        }
    }

    // Event: -

    public func fetchEvents<Response>() -> AsyncThrowingStream<([Event], Response), Error>? {
        eventStore?.fetchEvents()
    }

    public func fetchEvents<Response>(calendarID: Calendar.ID) -> AsyncThrowingStream<((added: [Event], modified: [Event], removed: [Event]), Response), Error>? {
        eventStore?.fetchEvents(calendarID: calendarID)
    }

    func placeholder(calendarID: String) -> Event? {
        eventStore?.placeholder(calendarID: calendarID)
    }

    public func update(event: Event) async throws {
        try await eventStore?.update(event: event)
        if events.contains(where: { $0.calendarID == event.calendarID && $0.id == event.id }) {
            Task.detached {
                self.events[event.calendarID, event.id] = event
            }
        } else {
            events.append(event)
        }
    }

    public func delete(event: Event) async throws {
        try await eventStore?.delete(event: event)
        Task.detached {
            self.events[event.calendarID, event.id] = nil
        }
    }
}
