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
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(review.description)
                    .padding(.bottom, 13)
                HStack {
                    //프로필 사진
                    if let image = reviewViewModel.reviewerImageDict[reviewViewModel.reviewer.profileId] {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(40)
                    }
                    VStack(alignment: .leading) {
                        Text(reviewViewModel.reviewer.name)
                            .font(.machachaHeadlineBold)
                        Text(review.updatedAt.getDay())
                            .font(.machachaHeadline)
                            .foregroundColor(.gray)
                    }
                }
            }//VStack
            .font(.machachaHeadline)
            .padding(.trailing, 53)
            
            
            //리뷰 음식 사진
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
        .onAppear {
            Task {
                await reviewViewModel.fetchReviewer(userId: review.reviewer)
            }
        }
    }
}

struct ReviewThumbnailListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewThumbnailListCellView(review: Review.getDummy2())
            .environmentObject(ReviewViewModel())
    }
}
