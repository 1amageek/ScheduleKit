//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2022/03/30.
//

import SwiftUI

struct ColorCircle: View {

    var color: Color

    init(_ color: Color) {
        self.color = color
    }
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8, alignment: .center)
    }
}

