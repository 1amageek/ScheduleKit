//
//  PersonStore.swift
//  
//
//  Created by nori on 2022/04/01.
//

import Foundation


public protocol PersonStore {

    func create(person: Person) async throws
    func fetchPersons(calendarID: Calendar.ID) -> AsyncThrowingStream<[Person], Error>?
}
