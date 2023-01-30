//
//  MapHeaderTagCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeaderTagCell: View {
    let image: String
    var tag: String {
        switch image {
        case "bbungbread":
            return "붕어빵"
        case "fishcake":
            return "어묵"
        case "sweetpotato":
            return "고구마"
        case "tteokboki":
            return "떡볶이"
        default:
            return "기타"
        }
    }
    
    var body: some View {
        VStack {
            Button {
                print("\(tag) tag Tapped")
            } label: {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 25)
                        .offset(x: +10)
                    Text(tag)
                        .offset(x: -20)
                        .font(.machachaFootnote)
                }
            }
        }
        .foregroundColor(.gray)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
        .padding(3)
    }
}

struct MapHeaderTagCell_Previews: PreviewProvider {
    static var image = "tteokboki"
    static var previews: some View {
        MapHeaderTagCell(image: image)
    }
}
