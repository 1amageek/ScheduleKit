//
//  EventView.swift
//  
//
//  Created by nori on 2022/03/30.
//

import SwiftUI

public struct EventView: View {

    @EnvironmentObject var model: CalendarModel

    @Environment(\.editMode) var editMode

    @Binding public var event: Event?

    @State var isPresented: Bool = false

    public init(_ event: Binding<Event?>) {
        self._event = event
    }

    var dateIntervalFormatter: DateIntervalFormatter = {
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.timeZone = .autoupdatingCurrent
        dateIntervalFormatter.dateStyle = .medium
        dateIntervalFormatter.timeStyle = .short
        return dateIntervalFormatter
    }()

    public var body: some View {
        if let event = event {
//            if editMode?.wrappedValue == .inactive {
//                content(event)
//            } else {
                EventEditor(event) { event in
                    self.event = event
                }
//            }
        }
    }

    func content(_ event: Event) -> some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text(dateIntervalFormatter.string(from: event.startDate, to: event.endDate))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let calendar = model.calendars.first(where: { $0.id == event.calendarID }) {
                    NavigationLink {
                        CalendarList(Binding($event)!.calendarID)
                    } label: {
                        HStack {
                            Text("カレンダー")
                            Spacer()
                            ColorCircle(calendar.color.color)
                            Text(calendar.title)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(event.title)
                    .font(.title)
                    .bold()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(role: .destructive) {

            } label: {
                Text("イベントを削除")
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

struct EventView_Previews: PreviewProvider {

    static let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1).date!
    static let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 3).date!
    
    static var previews: some View {
        NavigationView {
            EventView(.constant(Event(id: "0",
                                      calendarID: "0",
                                      title: "TITLE",
                                      occurrenceDate: startDate,
                                      isAllDay: false,
                                      startDate: startDate,
                                      endDate: endDate)))
        }
        .navigationViewStyle(.stack)
        .environmentObject(CalendarModel(calendars: [
            .init(id: "0", title: "title0"),
            .init(id: "1", title: "title1"),
            .init(id: "2", title: "title2"),
        ]))
    }
}
