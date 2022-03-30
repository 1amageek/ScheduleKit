//
//  Location.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation

public struct Location: Codable, Hashable {

    public var coordinate: Coordinate

    public var altitude: Double

    public init(coordinate: Coordinate, altitude: Double = 0) {
        self.coordinate = coordinate
        self.altitude = altitude
    }
}
