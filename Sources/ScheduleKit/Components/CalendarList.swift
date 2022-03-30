//
//  CalendarList.swift
//  
//
//  Created by nori on 2022/03/30.
//

import SwiftUI

public struct CalendarList: View {
    
    @EnvironmentObject var model: CalendarModel
    
    @Binding var selection: String
    
    public init(_ calendarID: Binding<String>) {
        self._selection = calendarID
    }
    
    public var body: some View {
        List {
            ForEach(model.calendars, id: \.id) { calendar in
                Button {
                    selection = calendar.id
                } label: {
                    HStack {
                        ColorCircle(calendar.color.color)
                        Text(calendar.title)
                        Spacer()
                        if calendar.id == selection {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("カレンダー")
    }
}

struct CalendarList_Previews: PreviewProvider {
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
