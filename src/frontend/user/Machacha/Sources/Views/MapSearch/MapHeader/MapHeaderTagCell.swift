//
//  MapHeaderTagCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeaderTagCell: View {
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    
    let image: String
    var tag: String {
        switch image {
        case "mainIcon":
            return "전체"
        case "bbungbread2":
            return "붕어빵"
        case "fishcake2":
            return "어묵"
        case "sweetpotato2":
            return "고구마"
        case "tteokboki2":
            return "떡볶이"
        default:
            return "기타"
        }
    }
    
    var body: some View {
        VStack {
            Button {
                Task {
                    if tag == "mainIcon" {
                        mapSearchViewModel.fetchFoodCarts()
                    } else {
                        mapSearchViewModel.fetchSortedMenu(by: tag)
                    }
                }

                print("foodCarts \(mapSearchViewModel.foodCarts)")
                print("\(tag) tag Tapped")
            } label: {
                HStack {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 25)
                        .padding([.top, .bottom], 3)
                    Text(tag)
                        .offset(x: -17)
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
    static var previews: some View {
        MapHeaderTagCell(image: "mainIcon")
            .environmentObject(MapSearchViewModel())
    }
}
