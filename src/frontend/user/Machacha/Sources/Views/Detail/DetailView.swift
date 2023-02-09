//
//  DetailView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import AlertToast

struct DetailView: View {
    var selectedStore: FoodCart
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var isFavorited: Bool = false
    @State var isVisited: Bool = false
    @State var showToast = false
    @State var opacity: Double = 0.8
    var basicImages = ["bbungbread2", "sweetpotato2", "takoyaki", "beverage"]
    var count = 0

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        if foodCartViewModel.imageDict.count > 0 {
                                ForEach(0..<4, id: \.self) { index in
                                    if let image = foodCartViewModel.imageDict[selectedStore.imageId[index]] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200, height: 200)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }//ForEach
                                if selectedStore.imageId.count > 4, let image = foodCartViewModel.imageDict[selectedStore.imageId[4]] {
                                    NavigationLink {
                                        ReviewView(selectedStore: selectedStore)
                                    } label: {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 200, height: 200)
                                            .aspectRatio(contentMode: .fit)
                                            .overlay {
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .opacity(0.5)
                                                Image(systemName: "plus")
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.gray)
                                            }
                                    }
                                    
                                }
                        } else {
                            ForEach(basicImages, id:\.self) { images in
                                Rectangle()
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(.white)
                                    .overlay {
                                        Image(images)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                    }
                            }
                        }
                    }//HStack
                }//ScrollView
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                
                HStack {
                    Text(selectedStore.name)
                        .font(.machachaTitle)
                        .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                    Spacer()
                    Text("★ \(String(format: "%.1f", selectedStore.grade))")
                        .foregroundColor(Color("Color3"))
                        .font(.machachaTitle2Bold)
                        .padding(.trailing, 20)
                        .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                }
                .padding(.leading, 20)
                .padding(.top, 20)
                .padding(.bottom, 5)
                
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                    Text("\(selectedStore.favoriteCnt)")
                        .padding(.trailing, 5)
                    Image(systemName: "checkmark.seal.fill")
                    Text("\(selectedStore.visitedCnt)")
                }
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                .padding(.horizontal, 20)
                .foregroundColor(.gray)
                
                IconTabView(selectedStore: selectedStore, isFavorited: $isFavorited, isVisited: $isVisited, opacity: $opacity) // 아이콘 4개
                StoreInformView(selectedStore: selectedStore, opacity: $opacity) // 가게정보
                    .padding(.leading, 20)
                FoodCartMenuView(selectedStore: selectedStore, opacity: $opacity) // 메뉴 정보
                    .padding(.leading, 20)
                ReviewThumbnailView(selectedStore: selectedStore, opacity: $opacity)
                    .padding(.leading, 20)
                
            }
            .onAppear {
                foodCartViewModel.isLoading = true // progressview를 위해 선언
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                    self.opacity = opacity == 0.4 ? 0.8 : 0.4
                }
                Task {
                    await foodCartViewModel.fetchFoodCarts()
                    reviewViewModel.reviews = await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                    profileViewModel.currentUser = try await profileViewModel.fetchUser()
                    if let user = profileViewModel.currentUser?.id {
                        isFavorited = try await foodCartViewModel.fetchUserFavoriteFoodCart(userId: user, foodCartId: selectedStore.id)
                        isVisited = try await foodCartViewModel.fetchUserVisitedFoodCart(userId: user, foodCartId: selectedStore.id)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) { // 스켈레톤 View를 위해
                            foodCartViewModel.isLoading = false
                        } // DispatchQueue
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    foodCartViewModel.isShowingReportSheet.toggle()
                } label: {
                    Image(systemName: "exclamationmark.circle")
                        .font(.machachaHeadline)
                        .foregroundColor(Color("Color3"))
                }
            }
        }
        .toast(isPresenting: $showToast){
            //댓글 삭제 후 화면 하단 토스트 메세지 출력
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "리뷰가 등록되었습니다.")
        }
        .fullScreenCover(isPresented: $foodCartViewModel.isShowingReportSheet) {
            ReportView(reportType: 1)
        }
        .fullScreenCover(isPresented: $foodCartViewModel.isShowingReviewSheet) {
            AddingReviewView(showToast: $showToast, selectedStore: selectedStore)
        }

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedStore: FoodCart.getDummy())
            .environmentObject(FoodCartViewModel())
            .environmentObject(ReviewViewModel())
            .environmentObject(MapSearchViewModel())
    }
}
