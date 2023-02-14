//
//  ReviewView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import SwiftUI

struct ReviewThumbnailView: View {
    var selectedStore: FoodCart
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @Binding var opacity: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.vertical, 15)
                NavigationLink {
                    ReviewView(selectedStore: selectedStore)
                } label: {
                    HStack(alignment: .top) {
                        Text("방문자 리뷰")
                            .foregroundColor(.black)
                            .font(.machachaTitle2Bold)
                        Text("\(reviewViewModel.reviews.count)")
                            .foregroundColor(Color("Color3"))
                            .font(.machachaTitle2Bold)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                            .font(.machachaTitle2)
                    }//HStack
                }
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                .padding(.trailing, 14)
                .padding(.bottom)
            
            //리뷰 두개 불러오기
            ForEach(reviewViewModel.twoReviews, id: \.self) { review in
                ReviewThumbnailListCellView(review: review)
                    .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                if reviewViewModel.twoReviews.last != review {
                    Divider()
                        .padding(.vertical, 5)
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            Task {
                reviewViewModel.twoReviews = try await reviewViewModel.fetchTwoReviews(foodCartId: selectedStore.id)
            }
        }
        .font(.machachaTitle2Bold)
        .padding(.bottom)
        .padding(.trailing, 5)
    }
}

//struct ReviewThumbnailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewThumbnailView(selectedStore: FoodCart.getDummy())
//            .environmentObject(ReviewViewModel())
//    }
//}
