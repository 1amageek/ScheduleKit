//
//  EventEditor.swift
//  
//
//  Created by nori on 2022/03/30.
//

import SwiftUI

public struct EventEditor: View {

    @EnvironmentObject var model: CalendarModel

    @Environment(\.dismiss) var dismiss: DismissAction

    @State var event: Event
    @State var startDate: Bool = false
    @State var endDate: Bool = false
    @State var location: String = ""
    @State var urlString: String = ""
    @State var notes: String = ""

    var completionText: String

    var onCompletion: (Event) -> Void

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    public init(_ event: Event, completionText: String = "完了", onCompletion: @escaping (Event) -> Void) {
        self._event = State(initialValue: event)
        self._location = State(initialValue: event.location ?? "")
        self._urlString = State(initialValue: event.url?.absoluteString ?? "")
        self._notes = State(initialValue: event.notes ?? "")
        self.completionText = completionText
        self.onCompletion = onCompletion
    }

    public var body: some View {
        List {
            Section {
                TextField("タイトル", text: $event.title)
            }

            Section {
                Toggle(isOn: $event.isAllDay.animation()) {
                    Text("終日")
                }
                HStack {
                    Text("開始")
                    Spacer()
                    Button {
                        withAnimation {
                            startDate = !startDate
                            if endDate {
                                endDate = false
                            }
                        }
                    } label: {
                        Text(dateFormatter.string(from: event.startDate))
                            .foregroundColor(startDate ? .accentColor : .primary)
                    }
                    .buttonStyle(.bordered)
                    if !event.isAllDay {
                        DatePicker(selection: $event.startDate, in: Date()..., displayedComponents: [.hourAndMinute]) {
                            EmptyView()
                        }
                        .fixedSize()
                    }
                }
                if startDate {
                    DatePicker(selection: $event.startDate, in: Date()..., displayedComponents: [.date]) {
                        EmptyView()
                    }
                    .datePickerStyle(.graphical)
                }
                HStack {
                    Text("終了")
                    Spacer()
                    Button {
                        withAnimation {
                            endDate = !endDate
                            if startDate {
                                startDate = false
                            }
                        }
                    } label: {
                        Text(dateFormatter.string(from: event.endDate))
                            .foregroundColor(endDate ? .accentColor : .primary)
                    }
                    .buttonStyle(.bordered)
                    if !event.isAllDay {
                        DatePicker(selection: $event.endDate, in: Date()..., displayedComponents: [.hourAndMinute]) {
                            EmptyView()
                        }
                        .fixedSize()
                    }
                }
                if endDate {
                    DatePicker(selection: $event.endDate, in: Date()..., displayedComponents: [.date]) {
                        EmptyView()
                    }
                    .datePickerStyle(.graphical)
                }
            }

            Section {
                NavigationLink {
                    CalendarList($event.calendarID)
                        .environmentObject(model)
                } label: {
                    HStack {
                        Text("カレンダー")
                    }
                }
                NavigationLink {
                    EmptyView() // TODO: カレンダー
                } label: {
                    HStack {
                        Text("出席予定者")
                    }
                }
            }

            Section {
                TextField("URL", text: $urlString)
                    .onChange(of: urlString) { newValue in
                        event.url = URL(string: newValue)
                    }
                TextEditor(text: $notes)
                    .frame(minHeight: 200)
                    .onChange(of: notes) { newValue in
                        event.notes = newValue
                    }
            }
        }
        .navigationTitle("イベントを編集")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("キャンセル")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onCompletion(event)
                    dismiss()
                } label: {
                    Text(completionText)
                }
            }
        }
    }
}

struct EventEditor_Previews: PreviewProvider {

    static let startDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1).date!
    static let endDate: Date = DateComponents(calendar: .init(identifier: .iso8601), timeZone: .autoupdatingCurrent, year: 2022, month: 4, day: 1, hour: 6).date!

    struct ContentView: View {
        @State var event: Event = Event(id: "0", calendarID: "0", title: "", occurrenceDate: startDate, isAllDay: false, startDate: startDate, endDate: endDate)

        var body: some View {
            EventEditor(event) { event in

            }
        }
    }

    static var previews: some View {
        NavigationView {
            ContentView()
        }
        .navigationViewStyle(.stack)
    }
}
