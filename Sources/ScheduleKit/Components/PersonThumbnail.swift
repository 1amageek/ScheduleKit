//
//  PersonThumbnail.swift
//  
//
//  Created by nori on 2022/04/01.
//

import SwiftUI

public struct PersonThumbnail: View {

    public var name: String

    public var thumbnailURL: URL?

    public init(name: String, thumbnailURL: URL? = nil) {
        self.name = name
        self.thumbnailURL = thumbnailURL
    }

    public var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .top, endPoint: .bottom))
            .frame(width: 32, height: 32, alignment: .center)
            .overlay {
                Text(name.prefix(1))
                    .font(.system(size: 24))
                    .bold()
                    .foregroundColor(.white)
            }
    }
}

struct PersonThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        PersonThumbnail(name: "NAME")
    }
}
