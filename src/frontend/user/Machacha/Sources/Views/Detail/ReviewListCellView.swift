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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var reviewer: User?
    @State private var profileImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
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
                    // 별점
                    HStack(alignment: .bottom) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color("Color3"))
                            .padding(.trailing, -4)
                            .offset(y: -2)
                        Text("\(review.gradeRounded)")
                        Text("| \(review.updatedAt.getDay())")
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Menu {
                    MenuView(review: review)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }//HStack
            
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
        .onAppear {
            Task {
                reviewer = try await reviewViewModel.fetchReviewer(userId: review.reviewer)
                if let reviewer = reviewer {
                    profileImage = try await profileViewModel.fetchImage(foodCartId: reviewer.id, imageName: reviewer.profileId)
                }
            }
        }
        .font(.machachaHeadline)
        
    }
    //        .onAppear {
    //            Task {
    //                await reviewViewModel.fetchReviews(foodCartId:"InzqNwgl15TytWNOdIZz")
    //            }
    //        }
}


struct ReviewListCellView_Previews: PreviewProvider {
    static var previews: some View {
        //        ReviewListCellView(review: Review.getDummy2())
        //            .environmentObject(ReviewViewModel())
        ReviewView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
