//
//  ReviewView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI

struct ReviewView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    var selectedStore: FoodCart
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color("Color3"))
                    .padding(.leading, 10)
                    
                Text("최신순")
                    .font(.machachaHeadline)
                    .padding(.bottom, 5)
            }
            .padding(.top, 15)
            ScrollView {
                ForEach(reviewViewModel.reviews, id: \.self) { review in
                    Divider()
                    ReviewListCellView(review: review)
                        .frame(width: 350, alignment: .leading)
                        .padding(.bottom, 10)
                }
            }//ScrollView
        }//VStack
//        .onAppear {
//            reviewViewModel.isLoading = true
//            Task {
//                await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
//                reviewViewModel.isLoading = false
//            }
//        }
        .navigationTitle(selectedStore.name)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
