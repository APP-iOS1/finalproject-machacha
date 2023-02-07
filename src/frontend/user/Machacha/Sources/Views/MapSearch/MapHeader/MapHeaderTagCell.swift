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
        case "takoyaki":
            return "타코야끼"
        case "hotteok":
            return "호떡"
        case "skewers":
            return "꼬치류"
        case "dessert":
            return "디저트"
        case "beverage":
            return "음료"
        default:
            return "기타"
        }
    }
    
    var body: some View {
        VStack {
            Button {
                var bestMenu = 9
                switch tag {
                case "붕어빵":
                    bestMenu = 0
                case "어묵":
                    bestMenu = 1
                case "고구마":
                    bestMenu = 2
                case "떡볶이":
                    bestMenu = 3
                case "타코야끼":
                    bestMenu = 4
                case "호떡":
                    bestMenu = 5
                case "꼬치류":
                    bestMenu = 6
                case "디저트":
                    bestMenu = 7
                case "음료":
                    bestMenu = 8
                case "기타":
                    bestMenu = 9
                default:
                    bestMenu = 9
                }
                if tag == "mainIcon" {
                    mapSearchViewModel.fetchFoodCarts()
                } else {
                    mapSearchViewModel.fetchSortedMenu(by: bestMenu)
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
