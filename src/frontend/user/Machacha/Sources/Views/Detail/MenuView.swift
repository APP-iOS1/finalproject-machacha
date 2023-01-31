//
//  MenuView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    var review: Review
    var body: some View {
        VStack {
            //본인이 작성한 리뷰에만 보이는 버튼
            Button {
                
            } label: {
                Text("수정")
            }

            Button {
                reviewViewModel.removeDiary(review: review)
                Task {
                    await reviewViewModel.fetchReviews(foodCartId:review.foodCartId)
                }
            } label: {
                Text("삭제")
            }
            
            //본인이 작성하지않은 리뷰에 보이는 버튼
            Button {
                
            } label: {
                Text("신고")
            }


        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(review: Review.getDummy1())
            .environmentObject(ReviewViewModel())
    }
}
