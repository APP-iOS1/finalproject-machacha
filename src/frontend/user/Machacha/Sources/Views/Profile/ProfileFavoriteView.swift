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
						ProfileCellView(isFavorite: .constant(true), foodCart: foodCart)
					} // ForEach
				} // VStack
			} header: {
				SectionHeaderView(name: "총 \(profileVM.favoriteUser.count)개")
			} // Section
		} // ScrollView
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
			}
		})
		.background(Color("bgColor"))
		.onAppear {
			Task {
				profileVM.favoriteUser = try await profileVM.fetchFavorite()
			}
		}
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
