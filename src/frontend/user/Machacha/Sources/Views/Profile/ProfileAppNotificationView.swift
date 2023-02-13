//
//  ProfileAppNotificationView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/11.
//

import SwiftUI

struct ProfileAppNotificationView: View {
	//MARK: Property wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@Environment(\.presentationMode) var presentation

	//MARK: Property
	let noti: UserNotification
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				Image("mainIcon")
					.resizable()
					.scaledToFit()
					.padding()
					.scaleEffect(0.8)

				VStack(spacing: 16) {
					VStack(spacing: 16) {
						Text(noti.title)
							.font(.machachaTitle2Bold)
							.frame(maxWidth: .infinity, alignment: .center)

						Text(noti.createdAt.getDay(format: "yyyy년 MM월 dd일 hh시"))
							.font(.machachaFootnote)
							.foregroundColor(Color(hex: "999899"))
							.frame(maxWidth: .infinity, alignment: .trailing)

					}
					.padding([.horizontal, .top])
					
					Divider()
					
					Text(noti.contents)
						.font(.machachaCallout)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineSpacing(8)
						.padding([.horizontal, .bottom])

				}
				.overlay(RoundedRectangle(cornerRadius: 8)
					.stroke(Color("textColor"), lineWidth: 0.1))
				.background(Color("cellColor"))
				.clipShape(RoundedRectangle(cornerRadius: 8))

				Spacer()
			}
		}
		.padding()
		.background(Color("bgColor"))
		.scrollContentBackground(.hidden)
		.navigationBarBackButtonHidden()
		.navigationBarTitle("공지사항".localized(language), displayMode: .inline)
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

struct ProfileAppNotificationView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ProfileAppNotificationView(noti: UserNotification.getDummy())
		}
    }
}
