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

final class EventStore: ObservableObject, ScheduleKit.EventStore {


    func fetchEvents<Response>() -> AsyncThrowingStream<((added: [Event], modified: [Event], removed: [Event]), Response), Error>? {
        return nil
    }

    func fetchEvents<FIRQuerySnapshot>(calendarID: ScheduleKit.Calendar.ID) -> AsyncThrowingStream<((added: [Event], modified: [Event], removed: [Event]), FIRQuerySnapshot), Error>? {
        return Firestore.firestore().collection("calendars").document(calendarID).collection("events").changes(type: Event.self) as! AsyncThrowingStream<((added: [Event], modified: [Event], removed: [Event]), FIRQuerySnapshot), Error>?
    }
//    func fetchEvents<FIRQuerySnapshot>(calendarID: ScheduleKit.Calendar.ID) -> AsyncThrowingStream<([Event], FIRQuerySnapshot), Error>? {
//        return Firestore.firestore().collection("calendars").document(calendarID).collection("events").updates(type: Event.self) as! AsyncThrowingStream<([Event], FIRQuerySnapshot), Error>?
//    }

    func update(event: Event) async throws {
        try Firestore.firestore().collection("calendars").document(event.calendarID).collection("events").document(event.id).setData(from: event, merge: true)
    }

    func delete(event: Event) async throws {
        try await Firestore.firestore().collection("calendars").document(event.calendarID).collection("events").document(event.id).delete()
    }

//    func fetchCalendars<FIRQuerySnapshot>() -> AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>? {
//        Firestore.firestore().collection("calendars").updates(type: ScheduleKit.Calendar.self) as! AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>?
//    }

}
