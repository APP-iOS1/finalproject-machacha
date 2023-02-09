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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Binding var isFavorited: Bool
    @Binding var isVisited: Bool
    @Binding var opacity: Double
    
    var body: some View {
        VStack(alignment: .center) {
            Divider()
                .padding(.vertical, 15)
            HStack(alignment: .bottom, spacing: 38) {
                Button {
                    isFavorited.toggle()
                    Task {
                        if let user = profileViewModel.currentUser {
                            await foodCartViewModel.fetchFavorite(isFavorited: isFavorited, user: user, foodCartId: selectedStore.id)
                        }
                    }
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 30))
                        Text("즐겨찾기")
                            .font(.headline)
                    }
                }
                Button {
                    isVisited.toggle()
                    Task {
                        if let user = profileViewModel.currentUser {
                            await foodCartViewModel.fetchVisited(isVisited: isVisited, user: user, foodCartId: selectedStore.id)
                        }
                    }
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: isVisited ? "checkmark.seal.fill" : "checkmark.seal")
                            .font(.system(size: 28))
                        Text("가봤어요")
                            .font(.headline)
                    }
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
            .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
        }
    }
}

//struct IconTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        IconTabView(selectedStore: FoodCart.getDummy())
//    }
//}
