//
//  MapHeaderTagCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeaderTagCell: View {
    let image: String
    let tag: String
    
    var body: some View {
        VStack {
            HStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Screen.maxWidth/7)
                    .offset(x: +10)
                Text(tag)
                    .offset(x: -20)
                    .font(.machachaFootnote)
            }
        }
        .foregroundColor(.gray)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
    }
}

struct MapHeaderTagCell_Previews: PreviewProvider {
    
    static var image = "tteokboki"
    static var tag = "떡볶이"
    static var previews: some View {
        MapHeaderTagCell(image: image, tag: tag)
    }
}
