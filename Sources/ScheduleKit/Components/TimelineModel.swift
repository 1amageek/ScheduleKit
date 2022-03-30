//
//  TimelineModel.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation
import TrackEditor
import SwiftColor


public class TimelineModel: ObservableObject {

    public var calendar: Foundation.Calendar = .init(identifier: .iso8601)

    public var timeZone: TimeZone = .autoupdatingCurrent

    public var options: TrackEditorOptions = TrackEditorOptions(interval: .minute(30), headerWidth: 120, trackHeight: 70, barWidth: 80)

    @Published public var calendars: [Calendar]

    @Published public var events: [Event]

    public var data: [String: [Event]] {
        Dictionary(grouping: events, by: { $0.calendarID })
    }

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

    public func fetchCalendars() -> AsyncThrowingStream<([Calendar]), Error>? {
        calendarStore?.fetchCalendars()
    }

    public func fetchEvents() -> AsyncThrowingStream<([Event]), Error>? {
        eventStore?.fetchEvents()
    }

    public func fetchEvents(calendarID: Calendar.ID) -> AsyncThrowingStream<([Event]), Error>? {
        eventStore?.fetchEvents(calendarID: calendarID)
    }
}
