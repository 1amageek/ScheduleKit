//
//  LaneRegioning.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import TrackEditor

extension Event: LaneRegioning {

    public func startRegion(_ interval: Interval) -> Int {
        let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute, .second], from: startDate)
        switch interval {
            case .month(let int):
                let (index, _) = components.month!.quotientAndRemainder(dividingBy: int)
                return index
            case .day(let int):
                let (index, _) = components.day!.quotientAndRemainder(dividingBy: int)
                return index
            case .hour(let int):
                let (index, _) = components.hour!.quotientAndRemainder(dividingBy: int)
                return index
            case .minute(let int):
                let time = components.hour! * 60 + components.minute!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
            case .second(let int):
                let time = components.hour! * 3600 + components.minute! * 60 + components.second!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
        }
    }

    public func endRegion(_ interval: Interval) -> Int {
        let components = Foundation.Calendar(identifier: .iso8601).dateComponents([.calendar, .timeZone, .year, .month, .day, .hour, .minute, .second], from: endDate)
        switch interval {
            case .month(let int):
                let (index, _) = components.month!.quotientAndRemainder(dividingBy: int)
                return index
            case .day(let int):
                let (index, _) = components.day!.quotientAndRemainder(dividingBy: int)
                return index
            case .hour(let int):
                let (index, _) = components.hour!.quotientAndRemainder(dividingBy: int)
                return index
            case .minute(let int):
                let time = components.hour! * 60 + components.minute!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
            case .second(let int):
                let time = components.hour! * 3600 + components.minute! * 60 + components.second!
                let (index, _) = time.quotientAndRemainder(dividingBy: int)
                return index
        }
    }
}
