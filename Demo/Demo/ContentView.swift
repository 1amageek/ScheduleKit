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

    @State var event: Event?

    var body: some View {
        NavigationView {
            Sidebar()
            TimelineCalendar(model.calendars) { calendar in
                TimelineLane(model.data[calendar.id] ?? [], calendarID: calendar.id, color: calendar.color)
                    .task {
                        do {
                            for try await ((added, modified, removed), _): ((added: [Event], modified: [Event], removed: [Event]), QuerySnapshot) in model.fetchEvents(calendarID: calendar.id)! {
                                print(added, modified, removed)
                                let current = self.model.events
                                if !added.isEmpty {
                                    let events = added.filter { event in
                                        !current.contains(where: { $0.id == event.id && $0.calendarID == event.calendarID })
                                    }
                                    self.model.events += events
                                }
                                if !modified.isEmpty {
                                    modified.forEach { event in
                                        self.model.events[event.calendarID, event.id] = event
                                    }
                                }
                                if !removed.isEmpty {
                                    self.model.events = removed.filter { event in
                                        current.contains(where: { $0.id == event.id && $0.calendarID == event.calendarID })
                                    }
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
                        self.event = self.model.eventStore?.placeholder(calendarID: calendar.id)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popover(item: $event, content: { event in
                        NavigationView {
                            EventEditor(event)
                        }
                        .navigationViewStyle(.automatic)
                        .frame(width: 400, height: 600, alignment: .center)
                        .environmentObject(model)
                    })
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
