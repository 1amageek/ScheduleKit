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

    func fetchEvents(calendarID: ScheduleKit.Calendar.ID) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>? {
        return Firestore.firestore().collection("calendars").document(calendarID).collection("events").changes(type: Event.self)
    }

    func placeholder(calendarID: String) -> Event? {
        let id = AutoID.generate(length: 4)
        let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 4).date!
        let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 7).date!
        let event = Event(id: id,
                          calendarID: calendarID,
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
