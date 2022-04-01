//
//  EventStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol EventStore {

    func fetchEvents() -> AsyncThrowingStream<[Event], Error>?
    func fetchEvents(calendarID: Calendar.ID) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>?

    func placeholder(calendarID: String) -> Event?

    func create(event: Event) async throws
    func update(before: Event, after: Event) async throws
    func delete(event: Event) async throws
}
