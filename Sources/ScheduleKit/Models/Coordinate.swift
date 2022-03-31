//
//  Coordinate.swift
//  
//
//  Created by nori on 2022/03/29.
//

import Foundation

public struct Coordinate: Codable, Hashable {

    public var latitude: Double

    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
