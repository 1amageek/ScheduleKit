//
//  TimelineCalendar.swift
//  
//
//  Created by nori on 2022/03/29.
//

import SwiftUI
import TrackEditor
import SwiftColor


public struct TimelineCalendar<Content: View>: View {

    @EnvironmentObject var model: CalendarModel

    @State var selection: Event?

    public var calendars: [Calendar]

    public var content: (Calendar, Binding<Event?>) -> Content

    var range: Range<Int> {
        switch model.options.interval {
            case .hour(let int):
                let interval = max(1, min(23, int))
                return 0..<(24 / interval)
            case .minute(let int):
                let interval = max(1, min(59, int))
                return 0..<(24 * 60 / interval)
            case .second(let int):
                let interval = max(1, min(59, int))
                return 0..<(24 * 60 * 60 / interval)
        }
    }

    public init(_ calendars: [Calendar], @ViewBuilder content: @escaping (Calendar, Binding<Event?>) -> Content) {
        self.calendars = calendars
        self.content = content
    }

    func anchor(geometory: GeometryProxy, preferences: [RegionPreference]) -> CGRect {
        if let bounds = preferences.first(where: { $0.event == selection  })?.bounds {
            return geometory[bounds]
        }
        return .zero
    }

    public var body: some View {
        GeometryReader { proxy in
            TrackEditor(range, options: model.options) {
                ForEach(calendars, id: \.id) { calendar in
                    content(calendar, $selection)
                }
            } header: {
                Color.white
                    .frame(height: 44)
            } ruler: { index in
                HStack {
                    Text(model.label(index))
                        .padding(.horizontal, 12)
                    Spacer()
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .tag(index)
            }
            .overlayPreferenceValue(RegionPreferenceKey.self) { value in
                let anchor = anchor(geometory: proxy, preferences: value)
                Color.clear
                    .popover(item: $selection, attachmentAnchor: .rect(.rect(anchor))) { event in
                        NavigationView {
                            EventView(event)
                        }
                        .navigationViewStyle(.automatic)
                        .frame(width: 400, height: 600)
                        .environmentObject(model)
                    }
            }
        }
    }
}

public struct PlaceholderViewState {
    public var size: CGSize = .zero
    public var offset: CGSize = .zero
}

public struct TimelineLane: View {

    @EnvironmentObject var model: CalendarModel

    @Binding var selection: Event?

    var data: Array<Event>

    var calendarID: String

    var color: RGB

    @State var draft: Event?

    @State var regionRreferences: [RegionPreference] = []

    public init(_ data: Array<Event>, selection: Binding<Event?>, calendarID: String, color: RGB) {
        self.data = data
        self._selection = selection
        self.calendarID = calendarID
        self.color = color
    }

    public var body: some View {
        TrackLane(data) { event in
            GeometryReader { proxy in
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(color.color)
                        .brightness(-0.4)
                    Text(model.dateFormatter.string(from: event.startDate))
                        .foregroundColor(color.color)
                        .brightness(-0.2)
                }
                .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(color.color.saturation(0.35).brightness(0.35))
                .cornerRadius(8)
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                .onTapGesture {
                    self.selection = event
                }
                .anchorPreference(key: RegionPreferenceKey.self, value: .bounds, transform: { [RegionPreference(event: event, bounds: $0)] })
            }
        } header: { _ in
            VStack(alignment: .leading) {
                if let calendar = model.calendars.first(where: { $0.id == calendarID }) {
                    Text(calendar.title)
                        .font(.title2)
                        .padding(6)
                }
                Spacer()
                Divider()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.white)
        } background: { index in
            HStack {
                Spacer()
                Divider()
            }
        }
    }
}

struct RegionPreference: Hashable {
    var event: Event
    var bounds: Anchor<CGRect>
    func hash(into hasher: inout Hasher) {
        hasher.combine(event.id)
        hasher.combine(event.calendarID)
    }
}

struct RegionPreferenceKey: PreferenceKey {

    static var defaultValue: [RegionPreference] = []

    static func reduce(value: inout [RegionPreference], nextValue: () -> [RegionPreference]) {
        value += nextValue()
    }
}

struct TimelineCalendar_Previews: PreviewProvider {

    static let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1).date!
    static let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 3).date!

    struct ContentView: View {

        @StateObject var model: CalendarModel = CalendarModel(calendars: [
            .init(id: "0", title: "title0", color: .purple),
            .init(id: "1", title: "title1", color: .red),
            .init(id: "2", title: "title2", color: .green),
            .init(id: "3", title: "title3", color: .blue),
            .init(id: "4", title: "title4", color: .cyan),
        ], events: [
            Event(id: "0",
                  calendarID: "0",
                  title: "TITLE",
                  occurrenceDate: startDate,
                  isAllDay: false,
                  startDate: startDate,
                  endDate: endDate),
            Event(id: "1",
                  calendarID: "1",
                  title: "TITLE",
                  occurrenceDate: startDate,
                  isAllDay: false,
                  startDate: startDate,
                  endDate: endDate),
            Event(id: "2",
                  calendarID: "2",
                  title: "TITLE",
                  occurrenceDate: startDate,
                  isAllDay: false,
                  startDate: startDate,
                  endDate: endDate),
        ])

        @State var isPresented: Bool = false

        var body: some View {
            NavigationView {
                Spacer()
                TimelineCalendar(model.calendars) { calendar, selection in
                    TimelineLane(model.data[calendar.id] ?? [], selection: selection, calendarID: calendar.id, color: calendar.color)
                }
                .environmentObject(model)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .popover(isPresented: $isPresented) {
                            let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 4).date!
                            let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 7).date!
                            let event = Event(id: "1",
                                              calendarID: "0",
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
            }
        }
    }

    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
