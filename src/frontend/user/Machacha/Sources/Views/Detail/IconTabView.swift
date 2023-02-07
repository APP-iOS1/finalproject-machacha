//
//  IconTabView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import SwiftUI

struct IconTabView: View {
    @State var selectedStore: FoodCart
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Divider()
                .padding(.vertical, 15)
            HStack(alignment: .bottom, spacing: 38) {
                Button {

                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30))
                        Text("즐겨찾기")
                            .font(.headline)
                    }
                }
                VStack(spacing: 10) {
                    Image(systemName: "checkmark.seal")
                        .font(.system(size: 28))
                    Text("가봤어요")
                        .font(.headline)
                }
                Button {
                    foodCartViewModel.isShowingReviewSheet.toggle()
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 32))
                        Text("리뷰쓰기")
                            .font(.headline)
                    }
                }

                VStack(spacing: 10) {
                    Image(systemName: "map")
                        .font(.system(size: 28))
                    Text("길찾기")
                        .font(.headline)
                }
                
            }//HStack
            .foregroundColor(Color("Color3"))
        }
    }
}

struct IconTabView_Previews: PreviewProvider {
    static var previews: some View {
        IconTabView(selectedStore: FoodCart.getDummy())
    }
}
