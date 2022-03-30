//
//  EventStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol EventStore {

    func fetchEvents() -> AsyncThrowingStream<([Event]), Error>?
    func fetchEvents(calendarID: Calendar.ID) -> AsyncThrowingStream<([Event]), Error>?
}
