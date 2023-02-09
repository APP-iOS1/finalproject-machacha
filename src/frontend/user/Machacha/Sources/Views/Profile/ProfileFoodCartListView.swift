//
//  ProfileFoodCartListView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileFoodCartListView: View {
	//MARK: Property wrapper
	@Environment(\.presentationMode) var presentation
	@EnvironmentObject var profileVM: ProfileViewModel
	@State private var isLoading = false // 리뷰관리 loading
	
	//MARK: Property
	let foodCartOfUserType: FoodCartOfUserType
	
	var body: some View {
		ScrollView {
			Section {
				LazyVStack(alignment: .leading, spacing: 15) {
					if foodCartOfUserType == .review {
						ForEach(profileVM.reviewUser) { review in
							ProfileFoodCartReviewCellView(isLoading: $isLoading, review: review)
						} // ForEach
					} else {
						ForEach(profileVM.foodCartUser) { foodCart in
							ProfileFoodCartCellView(foodCartOfUserType: foodCartOfUserType, foodCart: foodCart, isFavorite: profileVM.currentUser!.favoriteId.contains(foodCart.id))
						} // ForEach
					}
				} // VStack
			} header: {
				HStack {
					Text("총 \(profileVM.foodCartUser.count)개")
						.font(.machachaHeadlineBold)
						.setSkeletonView(opacity: 0.8, shouldShow: profileVM.isLoading)
					Spacer()
				} // HStack
				.padding([.horizontal, .top])
			} // Section
		} // ScrollView
		.refreshable(action: {
			if foodCartOfUserType == .review {
				isLoading = true
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
					isLoading = false
				} // DispatchQueue
			} else {
				profileVM.isLoading = true
				Task {
					profileVM.foodCartUser = try await profileVM.fetchFoodCartByType(foodCartType: foodCartOfUserType)
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
						profileVM.isLoading = false
					} // DispatchQueue
				} // Task
			}
		})
		.navigationBarBackButtonHidden()
		.navigationBarTitle("\(foodCartOfUserType.display)", displayMode: .large)
		.toolbarBackground(Color("Color3"), for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
		.toolbar(content: {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					self.presentation.wrappedValue.dismiss()
				} label: {
					HStack {
						Image(systemName: "chevron.left")
					}
				}
			} // ToolbarItem
		})
		.background(Color("bgColor"))
		.onAppear {
			profileVM.isLoading = true
			Task {
				profileVM.foodCartUser = try await profileVM.fetchFoodCartByType(foodCartType: foodCartOfUserType) // 타입별로 데이터를 비동기로 불러오는 값이 다르게 처리
				profileVM.isLoading = false
			} // Task
		} // ScrollView
	}
}

struct ProfileFoodCartListView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()
		
		NavigationView {
			ProfileFoodCartListView(foodCartOfUserType: .favorite)
				.environmentObject(profileVM)
				.onAppear {
					profileVM.currentUser = User.getDummy()
				}
				.environmentObject(FoodCartViewModel())
				.environmentObject(ReviewViewModel())
		}
	}
}
