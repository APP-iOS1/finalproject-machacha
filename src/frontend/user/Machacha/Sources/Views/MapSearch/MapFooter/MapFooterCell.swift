//
//  MapFooterCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapFooterCell: View {
    let foodCart: FoodCart
    let isFocus: Bool
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                // Main Image
                Image(foodCart.markerImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                VStack(alignment: .leading) {
                    // 이름
                    Text(foodCart.name)
                        .font(.machachaTitle3Bold)
                    // 주소
                    Text(foodCart.address)
                        .font(.machachaCaption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    HStack {
                        // 별점
                        Group {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("Color3"))
                            Text(foodCart.gradeRounded)
                                .padding([.leading], -7)
                        }
                        Text("|")
                        // 좋아요
                        Group {
                            Image(systemName: "square.and.pencil")
                            Text("\(foodCart.favoriteCnt)")
                                .padding([.leading], -7)
                        }
                        Text("|")
                        // 좋아요
                        Group {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color("Color1"))
                            Text("\(foodCart.favoriteCnt)")
                                .padding([.leading], -7)
                        }
                    }
                    .lineLimit(1)
                    .padding(1)
                    .font(.machachaCaption)
                    .opacity(0.7)
                }
                Spacer()
            }
        }
        .frame(width: Screen.maxWidth-100, height: 100)
        .background(isFocus ? Color.black : Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

struct MapFooterCell_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(MapSearchViewModel())
    }
}
