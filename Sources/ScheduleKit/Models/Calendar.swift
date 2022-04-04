//
//  Calendar.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import SwiftColor

extension EventAvailability {

    var value: Int {
        switch self {
            case .notSupported: return 0
            case .busy: return 1
            case .free: return 2
            case .tentative: return 3
            case .unavailable: return 4
        }
    }
}

public struct CalendarEventAvailabilityMask: OptionSet, Hashable, Codable, @unchecked Sendable {

    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static var busy: CalendarEventAvailabilityMask { .init(rawValue: 1 << EventAvailability.busy.value) }
    public static var free: CalendarEventAvailabilityMask { .init(rawValue: 1 << EventAvailability.free.value) }
    public static var tentative: CalendarEventAvailabilityMask { .init(rawValue: 1 << EventAvailability.tentative.value) }
    public static var unavailable: CalendarEventAvailabilityMask { .init(rawValue: 1 << EventAvailability.unavailable.value) }
    public static var all: CalendarEventAvailabilityMask { [.busy, .free, .tentative, .unavailable] }
}

public enum CalendarType: String, Codable, @unchecked Sendable {
    case local
    case calDAV
    case exchange
    case subscription
    case birthday
}

public struct Calendar: Identifiable, Codable, Hashable {

    public var id: String

    public var title: String

    public var type: CalendarType

    public var color: RGB

    public var supportedEventAvailabilities: CalendarEventAvailabilityMask

    public var metadata: [String: String]

    public init(id: String, title: String, type: CalendarType = .local, color: RGB = .green, supportedEventAvailabilities: CalendarEventAvailabilityMask = .all, metadata: [String: String] = [:]) {
        self.id = id
        self.title = title
        self.type = type
        self.color = color
        self.supportedEventAvailabilities = supportedEventAvailabilities
        self.metadata = metadata
    }
}

extension Array where Element == Calendar {

    public subscript(id: String) -> Calendar? {
        get {
            self.first(where: { $0.id == id })
        }
        set {
            if let newValue = newValue,
               let index = self.firstIndex(where:{ $0.id == id }) {
                self[index] = newValue
            } else if let index = self.firstIndex(where:{ $0.id == id }) {
                self.remove(at: index)
            }
        }
    }
}
