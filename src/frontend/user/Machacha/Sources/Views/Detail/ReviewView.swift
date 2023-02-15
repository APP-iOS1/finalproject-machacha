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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject var reportViewModel: ReportViewModel = ReportViewModel()
    @State var showToast = false
    @State var showEditToast = false
    @State var opacity: Double = 0.8
    var selectedStore: FoodCart
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                if reviewViewModel.reviews.count > 0 {
                    HStack(alignment: .center) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 7, height: 7)
                            .foregroundColor(Color("Color3"))
                            .padding(.leading, 10)
                            .offset(y: -1)
                        
                        Text("최신순")
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
                                                reviewViewModel.reviews = try await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                                            }
                                            showToast = true
                                        })
                                }
                                .fullScreenCover(isPresented: $reviewViewModel.isShowingEditSheet) {
                                    EditingReviewView(showToast: $showEditToast, selectedStore: selectedStore, review: review, text: review.description, grade: review.grade)
                                }
                                .fullScreenCover(isPresented: $reviewViewModel.isShowingReportSheet) {
                                    if let user = profileViewModel.currentUser?.id {
                                        ReportView(reportViewModel: reportViewModel, reportType: 1, targetId:review.id, userId: user)
                                    }
                                }
                        }
                        .padding(.bottom, 30)
                    }//ScrollView
                } else {
                    VStack(alignment: .center){
                        Spacer()
                        Image("dessert")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, -35)
                        
                        Text("아직 리뷰가 하나도 없어요!")
                            .font(.machachaTitle2)
                            .padding(.top, -15)
                        Spacer()
                    }
                    
                }
            }//VStack
        }
        .toolbar {
            //뒤로가기
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.machachaHeadline)
                        .foregroundColor(Color("Color3"))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .refreshable {
            Task {
                reviewViewModel.reviews = try await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
            }
        }
        .toast(isPresenting: $showToast){
            //댓글 삭제 후 화면 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 삭제되었습니다.")
        }
        .toast(isPresenting: $showEditToast){
            //댓글 수정 후 화면 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 수정되었습니다.")
        }
        .toast(isPresenting: $reportViewModel.reportShowToast){
            //제보 접수 후 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "신고가 접수되었습니다.")
        }
        .navigationBarTitle(selectedStore.name, displayMode: .inline)
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(selectedStore: FoodCart.getDummy())
            .environmentObject(ReviewViewModel())
    }
}
