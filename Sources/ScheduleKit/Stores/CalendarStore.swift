//
//  CalendarStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol CalendarStore {

    func fetchCalendars<Response>() -> AsyncThrowingStream<([Calendar], Response), Error>?

    func update(calendar: Calendar) async throws
    func delete(calendar: Calendar) async throws
}
