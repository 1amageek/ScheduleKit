//
//  Person.swift
//  
//
//  Created by nori on 2022/04/01.
//

import Foundation
import DocumentID

public struct Person: Identifiable, Codable, Hashable {

    @DocumentID public var id: String
    public var calendarID: String
    public var name: String
    @ExplicitNull public var thumbnailURL: URL?
    public var url: URL

    public init(id: String = AutoID.generate(length: 6), calendarID: String, name: String, thumbnailURL: URL? = nil, url: URL) {
        self.id = id
        self.calendarID = calendarID
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.url = url
    }
}
