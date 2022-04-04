//
//  EventStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol EventStore {

    func fetchEvents() -> AsyncThrowingStream<[Event], Error>?
    func fetchEvents(calendar: Calendar, range: Range<Date>) -> AsyncThrowingStream<(added: [Event], modified: [Event], removed: [Event]), Error>?

    func placeholder(calendar: Calendar) -> Event?

    func create(event: Event) async throws
    func update(before: Event, after: Event) async throws
    func delete(event: Event) async throws
}
