//
//  ProfileNotificationView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import SwiftUI

struct ProfileNotificationView: View {
	//MARK: Property Wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@Environment(\.presentationMode) var presentation
	@ObservedObject var tabbarManager = TabBarManager.shared

    var body: some View {
		ScrollView(showsIndicators: false) {
			Button {
				self.presentation.wrappedValue.dismiss() // 이전 화면으로 이동후
				self.tabbarManager.curTabSelection = .home
			} label: {
				Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			}
		} // ScrollView
		.background(Color("bgColor"))
		.scrollContentBackground(.hidden)
		.navigationBarBackButtonHidden()
		.navigationBarTitle("공지 및 알림".localized(language), displayMode: .inline)
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
    }
}

struct ProfileNotificationView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ProfileNotificationView()
		}
    }
}
