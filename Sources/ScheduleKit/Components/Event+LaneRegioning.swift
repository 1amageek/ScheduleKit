//
//  LaneRegioning.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import TrackEditor

extension Event: LaneRegioning {

    public func startRegion(_ options: TrackEditorOptions) -> Int {
        switch options.interval {
            case .month(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month], from: options.reference.date!, to: startDate)
                let (index, _) = components.month!.quotientAndRemainder(dividingBy: int)
                return index
            case .day(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day], from: options.reference.date!, to: startDate)
                let (index, _) = components.day!.quotientAndRemainder(dividingBy: int)
                return index
            case .hour(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour], from: options.reference.date!, to: startDate)
                let (index, _) = components.hour!.quotientAndRemainder(dividingBy: int)
                return index
            case .minute(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute], from: options.reference.date!, to: startDate)
                let time = components.hour! * 60 + components.minute!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
            case .second(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute, .second], from: options.reference.date!, to: startDate)
                let time = components.hour! * 3600 + components.minute! * 60 + components.second!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
        }
    }

    public func endRegion(_ options: TrackEditorOptions) -> Int {
        switch options.interval {
            case .month(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month], from: options.reference.date!, to: endDate)
                let (index, _) = components.month!.quotientAndRemainder(dividingBy: int)
                return index
            case .day(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day], from: options.reference.date!, to: endDate)
                let (index, _) = components.day!.quotientAndRemainder(dividingBy: int)
                return index
            case .hour(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour], from: options.reference.date!, to: endDate)
                let (index, _) = components.hour!.quotientAndRemainder(dividingBy: int)
                return index
            case .minute(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute], from: options.reference.date!, to: endDate)
                let time = components.hour! * 60 + components.minute!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
            case .second(let int):
                let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute, .second], from: options.reference.date!, to: endDate)
                let time = components.hour! * 3600 + components.minute! * 60 + components.second!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
        }
    }
}
