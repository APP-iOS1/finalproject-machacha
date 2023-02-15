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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var reviewer: User?
    @State private var profileImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(review.description)
                    .padding(.bottom, 13)
                HStack {
                    //프로필 사진
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 41, height: 41)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(40)
                    } else {
                        Color(uiColor: .lightGray)
                            .frame(width: 41, height: 41)
                            .cornerRadius(40)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(reviewer?.name ?? "사용자 이름")
                            .font(.machachaHeadline)
                        Text(review.updatedAt.getDay())
                            .font(.machachaSubhead)
                            .foregroundColor(.gray)
                    }
                }
            }//VStack
            .font(.machachaHeadline)
            .padding(.trailing, 53)
            
            Spacer()
            
            //리뷰 음식 사진
            if review.imageId.count > 0 {
                if let image = reviewViewModel.imageDict[review.imageId[0]] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                }
            }
        }//HStack
        .padding(.trailing, 20)
        .onAppear {
            Task {
                reviewer = try await reviewViewModel.fetchReviewer(userId: review.reviewer)
                if let reviewer = reviewer {
                    profileImage = try await profileViewModel.fetchImage(foodCartId: reviewer.id, imageName: reviewer.profileId)
                }
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
