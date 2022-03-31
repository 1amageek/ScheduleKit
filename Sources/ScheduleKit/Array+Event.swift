//
//  Array+Event.swift
//  
//
//  Created by nori on 2022/03/31.
//

import Foundation


extension Array where Element == Event {

    public subscript(calendarID: String, eventID: String) -> Event? {
        get {
            self.first(where: { $0.calendarID == calendarID && $0.id == eventID })
        }
        set {
            if let newValue = newValue,
               let index = self.firstIndex(where:{ $0.calendarID == calendarID && $0.id == eventID }) {
                self[index] = newValue
            } else if let index = self.firstIndex(where:{ $0.calendarID == calendarID && $0.id == eventID }) {
                self.remove(at: index)
            }
        }
    }
}
