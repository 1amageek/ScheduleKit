//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2022/03/31.
//

import SwiftUI

public struct CalendarEditor: View {

    @EnvironmentObject var model: CalendarModel

    @Environment(\.dismiss) var dismiss: DismissAction

    @State var calendar: Calendar

    public init(_ calendar: Calendar) {
        self._calendar = State(initialValue: calendar)
    }

    public var body: some View {
        List {
            TextField("タイトル", text: $calendar.title)

            Picker(selection: $calendar.color) {
                ForEach([RGB.red, RGB.orange, RGB.yellow, RGB.green, RGB.blue, RGB.purple], id: \.self) { color in
                    Circle()
                        .fill(color.color)
                        .frame(width: 16, height: 16, alignment: .center)
                        .tag(color)
                }
            } label: {
                Text("カラー")
            }
        }
        .navigationTitle("カレンダーを編集")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("キャンセル") {
                    dismiss()
                }
            }
            ToolbarItem {
                Button("完了") {
                    Task {
                        do {
                            try await self.model.update(calendar: calendar)
                            Task.detached { @MainActor in
                                dismiss()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}
//
//struct CalendarEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarEditor()
//    }
//}
