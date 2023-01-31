//
//  MapFooterCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapFooterCell: View {
    let foodCart: FoodCart
    
    var body: some View {
        VStack {
            HStack {
                // Main Image
                Image(foodCart.markerImage)
                    .padding()
                VStack(alignment: .leading) {
                    // 이름
                    Text(foodCart.name)
                    HStack {
                        // 별점
                        Group {
                            Image(systemName: "star.fill")
                            Text(foodCart.gradeRounded)
                        }
                        // 좋아요
                        Group {
                            Image(systemName: "heart.fill")
                            Text("\(foodCart.favoriteCnt)")
                        }
                    }

                    Text(foodCart.address)
                }.offset(x: -10)
            }
        }
        .frame(width: Screen.maxWidth-100)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
        .padding()
        .cornerRadius(5)
    }
}

struct MapFooterCell_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
