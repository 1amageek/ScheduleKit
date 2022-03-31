//
//  Sidebar.swift
//  Demo
//
//  Created by nori on 2022/03/31.
//

import SwiftUI
import ScheduleKit
import DocumentID
import FirestoreSwift
import FirebaseFirestore


struct Sidebar: View {

    @EnvironmentObject var model: CalendarModel

    @State var selection: ScheduleKit.Calendar?

    var body: some View {
        List {
            ForEach(model.calendars, id: \.id) { calendar in
                HStack {
                    Text(calendar.title)
                    Spacer()
                    Button {
                        selection = calendar
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }
        .popover(item: $selection, content: { calendar in
            Text("W")
        })
        .toolbar {
            Button {
                let calendar: ScheduleKit.Calendar = ScheduleKit.Calendar(id: AutoID.generate(length: 4), title: "Title")
                Task {
                    do {
                        try await self.model.update(calendar: calendar)
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
