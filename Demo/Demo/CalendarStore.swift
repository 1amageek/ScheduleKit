//
//  CalendarStore.swift
//  Demo
//
//  Created by nori on 2022/03/31.
//

import Foundation
import FirebaseFirestore
import FirestoreSwift
import ScheduleKit

final class CalendarStore: ObservableObject, ScheduleKit.CalendarStore {

    func fetchCalendars<FIRQuerySnapshot>() -> AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>? {
        Firestore.firestore().collection("calendars").updates(type: ScheduleKit.Calendar.self) as! AsyncThrowingStream<([ScheduleKit.Calendar], FIRQuerySnapshot), Error>?
    }

    func update(calendar: ScheduleKit.Calendar) async throws {
        try Firestore.firestore().collection("calendars").document(calendar.id).setData(from: calendar, merge: true)
    }

    func delete(calendar: ScheduleKit.Calendar) async throws {
        try await Firestore.firestore().collection("calendars").document(calendar.id).delete()
    }
}
