//
//  PersonStore.swift
//  Demo
//
//  Created by nori on 2022/04/01.
//

import Foundation
import FirebaseFirestore
import FirestoreSwift
import ScheduleKit

final class PersonStore: ObservableObject, ScheduleKit.PersonStore {

    func create(person: Person) async throws {
        try Firestore.firestore().collection("calendars").document(person.calendarID).collection("persons").document(person.id).setData(from: person, merge: true)
    }

    func fetchPersons(calendarID: ScheduleKit.Calendar.ID) -> AsyncThrowingStream<[Person], Error>? {
        return Firestore.firestore().collection("calendars").document(calendarID).collection("persons").updates(type: Person.self)
    }
}
