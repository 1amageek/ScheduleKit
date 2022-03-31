//
//  StructuredLocation.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation
import DocumentID
import CoreLocation

public struct StructuredLocation: Codable, Hashable {

    public var title: String

    @ExplicitNull public var geoLocation: Location?

    public var radius: Double

    public init(
        title: String = "",
        geoLocation: Location?,
        radius: Double
    ) {
        self.title = title
        self.geoLocation = geoLocation
        self.radius = radius
    }
}
