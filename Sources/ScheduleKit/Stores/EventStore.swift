//
//  EventStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol EventStore {

    func fetchEvents<Response>() -> AsyncThrowingStream<([Event], Response), Error>?
    func fetchEvents<Response>(calendarID: Calendar.ID) -> AsyncThrowingStream<((added: [Event], modified: [Event], removed: [Event]), Response), Error>?

    func placeholder(calendarID: String) -> Event?

    func update(event: Event) async throws
    func delete(event: Event) async throws
}
