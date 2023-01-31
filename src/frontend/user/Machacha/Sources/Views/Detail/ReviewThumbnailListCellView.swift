//
//  ReviewThumbnailListCellView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI

struct ReviewThumbnailListCellView: View {
    var review: Review
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(review.description)
                    .padding(.bottom, 5)
                Text(review.reviewer)
                    .font(.machachaHeadlineBold)
                Text(review.createdAt.getDay())
                    .foregroundColor(.gray)
            }//VStack
            .font(.machachaHeadline)
            .padding(.trailing, 10)
            
            Spacer()
            
            if review.imageId.count > 0 {
                if let image = reviewViewModel.imageDict[review.imageId[0]] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fit)
                }
            }
        }//HStack
        .padding(.trailing, 20)
//        .onAppear {
//            Task {
//                await reviewViewModel.fetchReviews(foodCartId:"InzqNwgl15TytWNOdIZz")
//            }
//        }
    }
}

struct ReviewThumbnailListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewThumbnailListCellView(review: Review.getDummy2())
            .environmentObject(ReviewViewModel())
    }
}
