//
//  Participant.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import DocumentID

public enum ParticipantRole: String, Codable, @unchecked Sendable {
    case unknown
    case required
    case optional
    case chair
    case nonParticipant
}

public enum ParticipantType: String, Codable, @unchecked Sendable {
    case unknown
    case person
    case room
    case resource
    case group
}

public enum ParticipantStatus: String, Codable, @unchecked Sendable {
    case unknown
    case pending
    case accepted
    case declined
    case tentative
    case delegated
    case completed
    case isProcess
}

public enum ParticipantScheduleStatus: String, Codable, @unchecked Sendable {
    case none
    case pending
    case sent
    case delivered
    case recipientNotRecognized
    case noPrivileges
    case deliveryFailed
    case cannotDeliver
    case recipientNotAllowed
}

public struct Participant: Codable, Hashable {

    @ExplicitNull public var name: String?
    @ExplicitNull public var thumbnailURL: URL?
    public var role: ParticipantRole
    public var status: ParticipantStatus
    public var type: ParticipantType
    public var url: URL

    public init(
        name: String?,
        thumbnailURL: URL? = nil,
        role: ParticipantRole = .unknown,
        status: ParticipantStatus = .unknown,
        type: ParticipantType = .unknown,
        url: URL
    ) {
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.role = role
        self.status = status
        self.type = type
        self.url = url
    }
}
