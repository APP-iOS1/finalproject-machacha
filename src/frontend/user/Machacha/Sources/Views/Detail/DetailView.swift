//
//  DetailView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct DetailView: View {
    var selectedStore: FoodCart
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(alignment: .top) {
                        if foodCartViewModel.isLoading { // 사진 데이터 로딩 중 progressview 표시
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(
                                    .black)))
                                .scaleEffect(3)
                                .frame(width: 200, height: 200, alignment: .trailing)
                        } else { // 스토리지 이미지 출력
                            ForEach(selectedStore.imageId, id: \.self) { imageKey in
                                if let image = foodCartViewModel.imageDict[imageKey] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }//ForEach
                        }
                    }//HStack
                }//ScrollView
                
                HStack {
                    Text(selectedStore.name)
                        .font(.machachaTitle)
                    Spacer()
                    Text("★ \(String(format: "%.1f", selectedStore.grade))")
                        .foregroundColor(Color("Color3"))
                        .font(.machachaTitle2Bold)
                        .padding(.trailing, 20)
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
                .padding(.horizontal, 20)
                .foregroundColor(.gray)
                
                IconTabView(selectedStore: selectedStore) // 아이콘 4개
                StoreInformView(selectedStore: selectedStore) // 가게정보
                    .padding(.leading, 20)
                FoodCartMenuView(selectedStore: selectedStore) // 메뉴 정보
                    .padding(.leading, 20)
                ReviewThumbnailView(selectedStore: selectedStore)
                    .padding(.leading, 20)
                
            }
            .onAppear {
                foodCartViewModel.isLoading = true // progressview를 위해 선언
                Task {
                    await foodCartViewModel.fetchFoodCarts()
                    await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                    profileViewModel.currentUser = try await profileViewModel.fetchUser()
                    foodCartViewModel.isLoading = false
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedStore: FoodCart.getDummy())
            .environmentObject(FoodCartViewModel())
            .environmentObject(ReviewViewModel())
    }
}
