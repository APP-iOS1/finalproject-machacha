//
//  ProfileFavoriteView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileFavoriteView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@Environment(\.presentationMode) var presentation
	
	var body: some View {
		ScrollView {
			Section {
				VStack(alignment: .leading, spacing: 15) {
					ForEach(profileVM.favoriteUser) { foodCart in
						ProfileCellView(isFavorite: .constant(true), foodCart: .constant(foodCart))
					} // ForEach
				} // VStack
			} header: {
				HStack {
					Text("총 \(profileVM.favoriteUser.count)개")
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
				profileVM.favoriteUser = try await profileVM.fetchFavorite()
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
					profileVM.isLoading = false
				} // DispatchQueue
			} // Task
		})
		.redacted(reason: profileVM.isLoading ? .placeholder : [])
		.navigationBarBackButtonHidden()
		.navigationBarTitle("즐겨찾기", displayMode: .large)
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
				profileVM.favoriteUser = try await profileVM.fetchFavorite()
				DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { // 스켈레톤 View를 위해
					profileVM.isLoading = false
				} // DispatchQueue
			} // Task
		} // ScrollView
	}
}

struct ProfileFavoriteView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()
		
		NavigationView {
			ProfileFavoriteView()
				.environmentObject(profileVM)
				.onAppear {
					profileVM.currentUser = User.getDummy()
				}
		}
	}
}
