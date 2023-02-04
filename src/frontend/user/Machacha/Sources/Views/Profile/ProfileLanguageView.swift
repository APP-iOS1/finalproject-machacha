//
//  ProfileLanguageView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/04.
//

import SwiftUI
import FlagKit

struct ProfileLanguageView: View {
	//MARK: Property wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@Environment(\.presentationMode) var presentation

	//MARK: Property
	let languageDict: [String: LanguageType] = ["한국어": .korean, "중국어": .chinese_simplified]

	var body: some View {
		List {
			ForEach(languageDict.sorted{$0.key < $1.key}, id: \.key) { languageDic in
				Button {
					LocalizationViewModel.shared.language = languageDic.value // 언어 변경 Action
				} label: {
					HStack(spacing: 16) {
						flagBy(countryCode: languageDic.value.flagCode) // 나라별 국기
							.overlay(RoundedRectangle(cornerRadius: 50)
								.stroke(Color("textColor"), lineWidth: 0.2))
						Text(languageDic.key.localized(language))
						Spacer()
						if languageDic.value == language { // 선택된 언어 표시
							Image(systemName: "checkmark")
						}
					} // HStack
				} // Button
				.foregroundColor(Color("textColor"))
			} // ForEach
		} // List
		.navigationBarBackButtonHidden()
		.navigationBarTitle("언어 설정".localized(language), displayMode: .inline)
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

extension ProfileLanguageView {
	func flagBy(countryCode: String) -> Image {
		guard let flag = Flag(countryCode: countryCode) else {
			return Image(systemName: "questionmark.circle")
		}
		return Image(uiImage: flag.image(style: .circle))
	}
}

struct ProfileLanguageView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ProfileLanguageView()
		}
	}
}
