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
                        .foregroundColor(Color("textColor"))
                        .lineLimit(2)
                    // 주소
                    Text(foodCart.address)
                        .font(.machachaCaption)
                        .foregroundColor(Color("textColor2"))
                        .lineLimit(1)
                    HStack {
                        // 즐겨찾기
                        Group {
                            Image(systemName: "heart.fill")
                            Text("\(foodCart.favoriteCnt)")
                                .padding([.leading], -7)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        Text("|")
                        // 가봤어요
                        Group {
                            Image(systemName: "checkmark.seal")
                            Text("\(foodCart.visitedCnt)")
                                .padding([.leading], -7)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        Text("|")
                        // 리뷰쓰기
                        Group {
                            Image(systemName: "square.and.pencil")
                            Text("\(foodCart.reviewId.count)")
                                .padding([.leading], -7)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .foregroundColor(Color("Color3"))
                    .padding(1)
                    .font(.machachaCaption)
                }
                Spacer()
            }
        }
        .frame(width: Screen.maxWidth-100, height: 100)
        .background(Color("cellColor"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

struct MapFooterCell_Previews: PreviewProvider {
    static var previews: some View {
        MapFooterCell(foodCart: FoodCart.getDummy(), isFocus: false)
    }
}
