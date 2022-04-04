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

    @StateObject var model: CalendarModel = CalendarModel(calendarStore: CalendarStore(), eventStore: EventStore(), personStore: PersonStore())

    @State var event: Event?

    var body: some View {
        NavigationView {
            Sidebar()
            TimelineCalendar(model.calendars) { calendar, selection in
                TimelineLane(model.data[calendar.id] ?? [], selection: selection, calendar: calendar, color: calendar.color)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        guard let calendar = self.model.calendars.first else {
                            return
                        }
                        self.model.defaultCalendar = calendar
                        self.event = self.model.eventStore?.placeholder(calendar: calendar)
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
                    for try await calendars in model.fetchCalendars()! {
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
