//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2022/03/31.
//

import SwiftUI
import ScheduleKit
import FirebaseFirestore

struct ContentView: View {

    @StateObject var model: CalendarModel = CalendarModel(calendarStore: CalendarStore(), eventStore: EventStore())

    @State var isPresented: Bool = false

    var body: some View {
        NavigationView {
            Sidebar()
            TimelineCalendar(model.calendars) { calendar in
                TimelineLane(model.data[calendar.id] ?? [], calendarID: calendar.id, color: calendar.color)
                    .task {
                        do {
                            for try await (events, _): ([Event], QuerySnapshot) in model.fetchEvents(calendarID: calendar.id)! {
                                self.model.events += events.filter { event in
                                    !self.model.events.contains(where: { $0.id == event.id && $0.calendarID == event.calendarID })
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        guard let calendar = self.model.calendars.first else {
                            return
                        }
                        self.model.defaultCalendar = calendar
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popover(isPresented: $isPresented) {                        
                        let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 4).date!
                        let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 7).date!
                        let event = Event(id: "1",
                                          calendarID: self.model.defaultCalendar!.id ,
                                          title: "TITLE",
                                          occurrenceDate: startDate,
                                          isAllDay: false,
                                          startDate: startDate,
                                          endDate: endDate)
                        NavigationView {
                            EventEditor(event)
                        }
                        .navigationViewStyle(.automatic)
                        .frame(width: 400, height: 600, alignment: .center)
                        .environmentObject(model)
                    }
                }
            }
            .task {
                do {
                    for try await (calendars, _): ([ScheduleKit.Calendar], QuerySnapshot) in model.fetchCalendars()! {
                        self.model.calendars = calendars
                    }
                } catch {
                    print(error)
                }
            }
        }
        .environmentObject(model)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
