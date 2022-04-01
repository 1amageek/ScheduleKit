//
//  GestureableBackground.swift
//  
//
//  Created by nori on 2022/03/30.
//

import SwiftUI

//struct GestureableBackground: View {
//    enum DragState {
//        case inactive
//        case pressing
//        case dragging(translation: CGSize)
//
//        var translation: CGSize {
//            switch self {
//                case .inactive, .pressing:
//                    return .zero
//                case .dragging(let translation):
//                    return translation
//            }
//        }
//
//        var isActive: Bool {
//            switch self {
//                case .inactive:
//                    return false
//                case .pressing, .dragging:
//                    return true
//            }
//        }
//
//        var isDragging: Bool {
//            switch self {
//                case .inactive, .pressing:
//                    return false
//                case .dragging:
//                    return true
//            }
//        }
//    }
//
//    @GestureState var dragState = DragState.inactive
//    @Binding var viewState: PlaceholderViewState?
//
//    init(_ viewState: Binding<PlaceholderViewState?>) {
//        self._viewState = viewState
//    }
//
//    var body: some View {
//        let minimumLongPressDuration = 0.5
//        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
//            .sequenced(before: DragGesture())
//            .updating($dragState) { value, state, transaction in
//                switch value {
//                        // Long press begins.
//                    case .first(true):
//                        state = .pressing
//                        // Long press confirmed, dragging may begin.
//                    case .second(true, let drag):
//                        state = .dragging(translation: drag?.translation ?? .zero)
//                        // Dragging ended or the long press cancelled.
//                    default:
//                        state = .inactive
//                }
//            }
//            .onEnded { value in
//                guard case .second(true, let drag?) = value else { return }
//                self.viewState?.offset.width += drag.translation.width
//                self.viewState?.offset.height += drag.translation.height
//            }
//        GeometryReader { proxy in
//            HStack {
//                Spacer()
//                Divider()
//            }
//    //        .overlay {
//    //            if dragState.isDragging {
//    //                Color.green
//    //                    .offset(
//    //                        x: viewState.width + dragState.translation.width,
//    //                        y: viewState.height + dragState.translation.height
//    //                    )
//    //            }
//    //        }
//            .contentShape(Rectangle())
//            .animation(nil)
//            .shadow(radius: dragState.isActive ? 8 : 0)
//            .animation(.linear(duration: minimumLongPressDuration))
//            .gesture(longPressDrag)
//            .onChange(of: dragState.isDragging) { newValue in
//                if newValue {
//                    self.viewState = PlaceholderViewState(size: proxy.size, offset: .zero)
//                } else {
//                    self.viewState = nil
//                }
//            }
////            .onChange(of: dragState.translation) { newValue in
////                self.viewState?.offset = dragState.translation
////            }
//        }
//
//
//        //        return Circle()
//        //                    .fill(Color.blue)
//        //                    .overlay(dragState.isDragging ? Circle().stroke(Color.white, lineWidth: 2) : nil)
//        //                    .frame(width: 100, height: 100, alignment: .center)
//        //                    .offset(
//        //                        x: viewState.width + dragState.translation.width,
//        //                        y: viewState.height + dragState.translation.height
//        //                    )
//        //                    .animation(nil)
//        //                    .shadow(radius: dragState.isActive ? 8 : 0)
//        //                    .animation(.linear(duration: minimumLongPressDuration))
//        //                    .gesture(longPressDrag)
//    }
//}
//struct GestureableBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        GestureableBackground(.constant(PlaceholderViewState()))
//    }
//}
