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


    var body: some View {
        List {
            ForEach(model.calendars, id: \.id) { calendar in
                Text(calendar.title)
            }
        }
        .toolbar {
            Button {
                let calendar: ScheduleKit.Calendar = ScheduleKit.Calendar(id: AutoID.generate(length: 4), title: "Title")
                model.calendars.append(calendar)
                _ = try? Firestore.firestore().collection("calendars").addDocument(from: calendar)
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
