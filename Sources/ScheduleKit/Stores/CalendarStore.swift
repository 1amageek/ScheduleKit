//
//  CalendarStore.swift
//  
//
//  Created by nori on 2022/03/30.
//

import Foundation

public protocol CalendarStore {

    func fetchCalendars() -> AsyncThrowingStream<([Calendar]), Error>?
}