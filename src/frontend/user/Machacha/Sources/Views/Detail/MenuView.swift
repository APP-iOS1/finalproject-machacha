//
//  MenuView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
  
    
    var review: Review
    
    var body: some View {
        VStack {
            var _ = print("User Id = \(profileViewModel.currentUser?.id)")
            var _ = print("Review Id = \(review.reviewer)")
            //본인이 작성한 리뷰에만 보이는 버튼
            if profileViewModel.currentUser?.id == review.reviewer {
                Button {
                    reviewViewModel.isShowingEditSheet = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("수정")
                    }
                }
                
                Button(role: .destructive) {
                    reviewViewModel.isShowingAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("삭제")
                    }
                }
            } else {
                
                //본인이 작성하지않은 리뷰에 보이는 버튼
                Button {
                    reviewViewModel.isShowingReportSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "light.beacon.max")
                        Text("신고")
                    }
                }
            }


        }
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView(review: Review.getDummy1())
//            .environmentObject(ReviewViewModel())
//    }
//}
