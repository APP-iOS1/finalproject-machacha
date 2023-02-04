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
	
	//MARK: Property
	let foodCartOfUserType: FoodCartOfUserType
	
	var body: some View {
		ScrollView {
			Section {
				VStack(alignment: .leading, spacing: 15) {
					ForEach(profileVM.foodCartUser) { foodCart in
						ProfileFoodCartCellView(foodCart: foodCart, isFavorite: profileVM.currentUser!.favoriteId.contains(foodCart.id))
					} // ForEach
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
			profileVM.isLoading = true
			Task {
				profileVM.foodCartUser = try await profileVM.fetchFoodCartByType(foodCartType: foodCartOfUserType)
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
					profileVM.isLoading = false
				} // DispatchQueue
			} // Task
		})
		.redacted(reason: profileVM.isLoading ? .placeholder : [])	// 콘텐츠 모자이크
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
					Image(systemName: "chevron.left")
				}
			} // ToolbarItem
		})
		.background(Color("bgColor"))
		.onAppear {
			profileVM.isLoading = true
			Task {
				profileVM.foodCartUser = try await profileVM.fetchFoodCartByType(foodCartType: foodCartOfUserType) // 타입별로 데이터를 비동기로 불러오는 값이 다르게 처리
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
					profileVM.isLoading = false
				} // DispatchQueue
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
