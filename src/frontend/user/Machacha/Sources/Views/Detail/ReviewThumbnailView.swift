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
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.vertical, 15)
            HStack {
                Text("방문자 리뷰")
                Text("\(reviewViewModel.reviews.count)")
                    .foregroundColor(Color("Color3"))
                Spacer()
                NavigationLink {
                    ReviewView(selectedStore: selectedStore)
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.gray)
                        .font(.machachaTitle2)
                }
                .padding(.trailing, 14)
            }//HStack
            ForEach(reviewViewModel.twoReviews, id: \.self) { review in
                ReviewThumbnailListCellView(review: review)
            }
        }
        .onAppear {
            Task {
                await reviewViewModel.fetchTwoReviews(foodCartId: selectedStore.id)
            }
        }
        .font(.machachaTitle2Bold)
        .padding(.bottom)
        .padding(.trailing, 5)
    }
}

struct ReviewThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewThumbnailView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
