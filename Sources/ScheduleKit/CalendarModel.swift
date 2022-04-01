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

    public var options: TrackEditorOptions = TrackEditorOptions(interval: .minute(30), headerWidth: 230, trackHeight: 96, barWidth: 80)

    @Published public var calendars: [Calendar] = []

    @Published public var data: [String: [Event]] = [:]

    public var events: [Event] {
        didSet {
            self.data = Dictionary(grouping: events, by: { $0.calendarID })
        }
    }

    public var defaultCalendar: Calendar?

    public var calendarStore: CalendarStore?

    public var eventStore: EventStore?

    public var personStore: PersonStore?


    public init(calendars: [Calendar] = [], events: [Event] = []) {
        self.calendars = calendars
        self.events = events
    }

    public convenience init(calendarStore: CalendarStore? = nil, eventStore: EventStore? = nil, personStore: PersonStore? = nil) {
        self.init(calendars: [], events: [])
        self.calendarStore = calendarStore
        self.eventStore = eventStore
        self.personStore = personStore
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

    public func fetchCalendars() -> AsyncThrowingStream<[Calendar], Error>? {
        calendarStore?.fetchCalendars()
    }

    public func update(calendar: Calendar) async throws {
        try await calendarStore?.update(calendar: calendar)
        if calendars.contains(where: { $0.id == calendar.id }) {
            Task.detached { @MainActor in
                self.calendars[calendar.id] = calendar
            }
        } else {
            calendars.append(calendar)
        }
    }

    public func delete(calendar: Calendar) async throws {
        try await calendarStore?.delete(calendar: calendar)
        Task.detached { @MainActor in
            self.calendars[calendar.id] = nil
        }
    }

    // Event: -

    public func fetchEvents() -> AsyncThrowingStream<[Event], Error>? {
        eventStore?.fetchEvents()
    }

    public func fetchEvents(calendarID: Calendar.ID) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>? {
        eventStore?.fetchEvents(calendarID: calendarID)
    }

    func placeholder(calendarID: String) -> Event? {
        eventStore?.placeholder(calendarID: calendarID)
    }

    public func create(event: Event) async throws {
        try await eventStore?.create(event: event)
        Task.detached { @MainActor in
            self.events[event.calendarID, event.id] = event
        }
    }

    public func update(before: Event, after: Event) async throws {
        try await eventStore?.update(before: before, after: after)
        Task.detached { @MainActor in
            self.events[after.calendarID, after.id] = after
        }
        Task.detached { @MainActor in
            self.events[before.calendarID, before.id] = nil
        }
    }

    public func delete(event: Event) async throws {
        try await eventStore?.delete(event: event)
        Task.detached { @MainActor in
            self.events[event.calendarID, event.id] = nil
        }
    }

    // Person: -

    public func create(person: Person) async throws {
        try await personStore?.create(person: person)
    }

    public func fetchPersons(calendarID: Calendar.ID) -> AsyncThrowingStream<[Person], Error>? {
        personStore?.fetchPersons(calendarID: calendarID)
    }
}
