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
    var selectedStore: FoodCart
    
    var body: some View {
        VStack(alignment: .leading) {
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
                            // 허용안함, FaceID error
                            Alert(
                                title: Text("삭제하시겠습니까?"),
                                primaryButton: .default(Text("취소")) {
                                },
                                secondaryButton: .default(Text("삭제")) {
//                                    reviewViewModel.removeDiary(review: review)
                                    Task {
                                        await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                                    }
                                    showToast = true
                                })
                        }
                }
            }//ScrollView
        }//VStack
        .toast(isPresenting: $showToast){
            
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 삭제되었습니다.")
            
            //Choose .hud to toast alert from the top of the screen
            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
        }
//        .onAppear {
//             reviewViewModel.isLoading = true
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
