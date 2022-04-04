//
//  CalendarModel.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation
import TrackEditor
import SwiftColor

public enum CalendarDisplayMode: Hashable {
    case month(year: Int, month: Int)
    case day(year: Int, month: Int, day: Int)

    public var year: Int {
        switch self {
            case .month(let year, _):
                return year
            case .day(let year, _, _):
                return year
        }
    }

    public var month: Int {
        switch self {
            case .month(_, let month):
                return month
            case .day(_, let month, _):
                return month
        }
    }

    public var day: Int {
        switch self {
            case .month(_, _):
                return 1
            case .day(_, _, let day):
                return day
        }
    }

    public static var `default`:  CalendarDisplayMode {
        let dateComponents = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day], from: Date())
        let displayMode: CalendarDisplayMode = .day(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
        return displayMode
    }
}

public class CalendarModel: ObservableObject {

    public var calendar: Foundation.Calendar = .init(identifier: .iso8601)

    public var timeZone: TimeZone = .autoupdatingCurrent

    @Published public var displayMode: CalendarDisplayMode {
        didSet {
            changeInterval()
            reloadData()
        }
    }

    @Published public var options: TrackEditorOptions

    @Published public var calendars: [Calendar] = []

    @Published public var data: [String: [Event]] = [:]

    public var events: [Event] {
        didSet { reloadData() }
    }

    public var defaultCalendar: Calendar?

    public var calendarStore: CalendarStore?

    public var eventStore: EventStore?

    public var personStore: PersonStore?

    public var dateComponents: DateComponents {
        switch displayMode {
            case .month(let year, let month):
                return DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month)
            case .day(let year, let month, let day):
                return DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month, day: day)
        }
    }

    public var range: Range<Date> {
        switch displayMode {
            case .month(_, _):
                let startDate = dateComponents.date!
                let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
                return startDate..<endDate
            case .day(_, _, _):
                let startDate = dateComponents.date!
                let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                return startDate..<endDate
        }
    }

    static func options(displayMode: CalendarDisplayMode, calendar: Foundation.Calendar, timeZone: TimeZone) -> TrackEditorOptions {
        switch displayMode {
            case .month(let year, let month):
                let dateComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month)
                return TrackEditorOptions(interval: .day(1), reference: dateComponents, headerWidth: 230, trackHeight: 90, barWidth: 80)
            case .day(let year, let month, let day):
                let dateComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month, day: day)
                return TrackEditorOptions(interval: .minute(30), reference: dateComponents, headerWidth: 230, trackHeight: 90, barWidth: 80)
        }
    }

    public init(calendars: [Calendar] = [], events: [Event] = [], displayMode: CalendarDisplayMode = CalendarDisplayMode.default) {
        let dateComponents = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day], from: Date())
        let displayMode: CalendarDisplayMode = .day(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
        self._displayMode = Published(initialValue: displayMode)
        self.options = Self.options(displayMode: displayMode, calendar: self.calendar, timeZone: self.timeZone)
        self.calendars = calendars
        self.events = events
    }

    public convenience init(displayMode: CalendarDisplayMode = CalendarDisplayMode.default, calendarStore: CalendarStore? = nil, eventStore: EventStore? = nil, personStore: PersonStore? = nil) {
        self.init(calendars: [], events: [], displayMode: displayMode)
        self.calendarStore = calendarStore
        self.eventStore = eventStore
        self.personStore = personStore
    }

    var navigationTitle: String {
        titleDateFormatter.string(from: dateComponents.date!)
    }

    var titleDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .autoupdatingCurrent
        switch displayMode {
            case .month(_, _):
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyM", options: 0, locale: .autoupdatingCurrent)
            case .day(_, _, _):
                dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMd", options: 0, locale: .autoupdatingCurrent)
        }
        return dateFormatter
    }

    var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter: DateComponentsFormatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var dateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        switch options.interval {
            case .month(_):
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: .autoupdatingCurrent)
            case .day(_):
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: .autoupdatingCurrent)
            case .hour(_):
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            case .minute(_):
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            case .second(_):
                formatter.dateStyle = .none
                formatter.timeStyle = .short
        }
        return formatter
    }

    public func dateComponents(_ index: Int) -> DateComponents {
        switch options.interval {
            case .month(let int):
                let month = int * index
                return DateComponents(calendar: calendar, timeZone: timeZone, month: month)
            case .day(let int):
                let day = int * index
                return DateComponents(calendar: calendar, timeZone: timeZone, day: day)
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
        switch options.interval {
            case .month(_), .day(_): return dateFormatter.string(from: dateComponents.date!)
            default: return dateComponentsFormatter.string(from: dateComponents)!
        }
    }

    public func prev() {
        switch displayMode {
            case .month(let year, let month):
                displayMode = .month(year: year, month: month - 1)
            case .day(let year, let month, let day):
                displayMode = .day(year: year, month: month, day: day - 1)
        }
    }

    public func next() {
        switch displayMode {
            case .month(let year, let month):
                displayMode = .month(year: year, month: month + 1)
            case .day(let year, let month, let day):
                displayMode = .day(year: year, month: month, day: day + 1)
        }
    }

    private func reloadData() {
        Task {
            
        }
        let filtered = events.filter({ range.lowerBound <= $0.startDate && $0.startDate < range.upperBound || range.lowerBound <= $0.endDate && $0.endDate < range.upperBound  })
        self.data = Dictionary(grouping: filtered, by: { $0.calendarID })
    }

    private func changeInterval() {
        self.options = Self.options(displayMode: displayMode, calendar: calendar, timeZone: timeZone)
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

    public func fetchEvents(calendar: Calendar, range: Range<Date>) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>? {
        eventStore?.fetchEvents(calendar: calendar, range: range)
    }

    func placeholder(calendar: Calendar) -> Event? {
        eventStore?.placeholder(calendar: calendar)
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
            self.events[before.calendarID, before.id] = nil
        }
        Task.detached { @MainActor in
            self.events[after.calendarID, after.id] = after
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
