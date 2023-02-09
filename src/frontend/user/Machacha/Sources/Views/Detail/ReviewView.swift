//
//  ReviewView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import SwiftUI
import AlertToast

struct ReviewView: View {
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @State var showToast = false
    @State var showEditToast = false
    var selectedStore: FoodCart
    
    var body: some View {
        VStack(alignment: .leading) {
            if reviewViewModel.reviews.count > 0 {
                HStack(alignment: .center) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 5, height: 5)
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
                            .padding(.vertical)
                        ReviewListCellView(review: review)
                            .frame(width: 350, alignment: .leading)
                            .alert(isPresented: $reviewViewModel.isShowingAlert) {
                                //댓글 삭제 시 알럿
                                Alert(
                                    title: Text("삭제하시겠습니까?"),
                                    primaryButton: .default(Text("취소")) {
                                    },
                                    secondaryButton: .default(Text("삭제")) {
                                        reviewViewModel.removeDiary(review: review)
                                        Task {
                                            reviewViewModel.reviews = await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                                        }
                                        showToast = true
                                    })
                            }
                            .fullScreenCover(isPresented: $reviewViewModel.isShowingEditSheet) {
                                EditingReviewView(showToast: $showEditToast, selectedStore: selectedStore, review: review, text: review.description, grade: review.grade)
                            }
                    }
                }//ScrollView
            } else {
                VStack(alignment: .center){
                    Spacer()
                    Image("dessert")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("아직 리뷰가 하나도 없어요!")
                        .font(.machachaTitle2)
                    Spacer()
                }

            }
        }//VStack
        .toast(isPresenting: $showToast){
            //댓글 삭제 후 화면 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 삭제되었습니다.")
        }
        .toast(isPresenting: $showEditToast){
            //댓글 삭제 후 화면 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 수정되었습니다.")
        }
        .fullScreenCover(isPresented: $reviewViewModel.isShowingReportSheet) {
            ReportView(reportType: 2)
        }
        //        .onAppear {
        //             reviewViewModel.isLoading = true
        //            Task {
        //                await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
        //                reviewViewModel.isLoading = false
        //            }
        //        }
        .navigationBarTitle(selectedStore.name, displayMode: .inline)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
