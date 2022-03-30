//
//  Alarm.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import DocumentID

public enum AlarmProximity: String, Codable, @unchecked Sendable {
    case none
    case enter
    case leave
}

public enum AlarmType: String, Codable, @unchecked Sendable {
    case display
    case audio
    case procedure
    case email
}

public struct Alarm: Codable, Hashable {
    public var type: AlarmType
    public var proximity: AlarmProximity
    @ExplicitNull public var emailAddress: String?
    @ExplicitNull public var soundName: String?

    public init(
        type: AlarmType,
        proximity: AlarmProximity,
        emailAddress: String?,
        soundName: String?
    ) {
        self.type = type
        self.proximity = proximity
        self.emailAddress = emailAddress
        self.soundName = soundName
    }

}
