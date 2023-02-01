//
//  ReviewListCellView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI

struct ReviewListCellView: View {
    var review: Review
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                    HStack {
                    Text(review.reviewer)
                        .font(.machachaHeadlineBold)
                        Spacer()
                        Menu {
                            MenuView(review: review)
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                        }
                    }//HStack
                    Text(review.createdAt.getDay())
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("Color3"))
                        Text("\(review.gradeRounded)")
                    }
                }
                
            .font(.machachaHeadline)
            
            if reviewViewModel.isLoading { // 사진 데이터 로딩 중 progressview 표시
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(
                        .black)))
                    .scaleEffect(3)
                    .frame(width: 200, height: 200)
            } else { // 스토리지 이미지 출력
                if review.imageId.count == 1 {
                    ForEach(review.imageId, id: \.self) { imageKey in
                        if let image = reviewViewModel.imageDict[imageKey] {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 350, height: 200)
                                .aspectRatio(contentMode: .fit)
                        }
                    }//ForEach
                } else {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(review.imageId, id: \.self) { imageKey in
                                if let image = reviewViewModel.imageDict[imageKey] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }//ForEach
                        }
                    }
                }
            }
            Text(review.description)
                .padding(.top, 7)
        }
//        .onAppear {
//            Task {
//                await reviewViewModel.fetchReviews(foodCartId:"InzqNwgl15TytWNOdIZz")
//            }
//        }
        .font(.machachaHeadline)
    }
}

struct ReviewListCellView_Previews: PreviewProvider {
    static var previews: some View {
//        ReviewListCellView(review: Review.getDummy2())
//            .environmentObject(ReviewViewModel())
        ReviewView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
