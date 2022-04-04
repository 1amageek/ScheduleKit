//
//  EventStore.swift
//  Demo
//
//  Created by nori on 2022/03/31.
//

import Foundation
import FirebaseFirestore
import FirestoreSwift
import ScheduleKit
import DocumentID

final class EventStore: ObservableObject, ScheduleKit.EventStore {


    func fetchEvents() -> AsyncThrowingStream<[Event], Error>? {
        return nil
    }

    func fetchEvents(calendar: ScheduleKit.Calendar, range: Range<Date>) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>? {
        return Firestore.firestore()
            .collection("calendars")
            .document(calendar.id)
            .collection("events")
            .whereField("startDate", isGreaterThanOrEqualTo: range.lowerBound)
            .whereField("startDate", isLessThan: range.upperBound)
            .changes(type: Event.self)
    }

    func placeholder(calendar: ScheduleKit.Calendar) -> Event? {
        let id = AutoID.generate(length: 4)
        let startDate: Date = Date()
        let endDate: Date = Foundation.Calendar.init(identifier: .iso8601).date(byAdding: .hour, value: 1, to: startDate)!
        let event = Event(id: id,
                          calendarID: calendar.id,
                          title: "TITLE",
                          occurrenceDate: startDate,
                          isAllDay: false,
                          startDate: startDate,
                          endDate: endDate)
        return event
    }

    func create(event: Event) async throws {
        try Firestore.firestore().collection("calendars").document(event.calendarID).collection("events").document(event.id).setData(from: event)
    }

    func update(before: Event, after: Event) async throws {
        let batch = Firestore.firestore().batch()
        batch.deleteDocument(Firestore.firestore().collection("calendars").document(before.calendarID).collection("events").document(before.id))
        try batch.setData(from: after, forDocument: Firestore.firestore().collection("calendars").document(after.calendarID).collection("events").document(after.id), merge: true)
        try await batch.commit()
    }

    func delete(event: Event) async throws {
        try await Firestore.firestore().collection("calendars").document(event.calendarID).collection("events").document(event.id).delete()
    }

//    func fetchCalendars<FIRQuerySnapshot>() -> AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>? {
//        Firestore.firestore().collection("calendars").updates(type: ScheduleKit.Calendar.self) as! AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>?
//    }

}
