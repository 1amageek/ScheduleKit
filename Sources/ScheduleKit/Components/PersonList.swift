//
//  PersonList.swift
//  
//
//  Created by nori on 2022/04/01.
//

import SwiftUI


public struct PersonList: View {

    @EnvironmentObject var model: CalendarModel

    @Binding var selections: Set<Person>

    @State var persons: [Person] = []

    var calendarID: String

    public init(calendarID: String, _ selections: Binding<Set<Person>>) {
        self.calendarID = calendarID
        self._selections = selections
    }

    public var body: some View {
        List {
            ForEach(persons, id: \.id) { person in
                Button {
                    if selections.contains(person) {
                        selections.remove(person)
                    } else {
                        selections.insert(person)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(person.name)
                        }
                        Spacer()
                        if selections.contains(person) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.accentColor)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("アサイン")
        .task {
            do {
                for try await persons in model.fetchPersons(calendarID: calendarID)! {
                    self.persons = persons
                }
            } catch {
                print(error)
            }
        }
    }
}

struct PersonList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarList(.constant("0"))
        }
#if os(iOS)
        .navigationViewStyle(.stack)
#endif
        .environmentObject(CalendarModel(calendars: [
            .init(id: "0", title: "title0"),
            .init(id: "1", title: "title1"),
            .init(id: "2", title: "title2"),
        ]))
    }
}
