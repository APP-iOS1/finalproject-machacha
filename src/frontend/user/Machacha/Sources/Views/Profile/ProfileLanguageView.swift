//
//  ProfileLanguageView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/04.
//

import SwiftUI

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
					LocalizationViewModel.shared.language = languageDic.value
				} label: {
					HStack {
						Text(languageDic.key.localized(language))
						Spacer()
						if languageDic.value == language {
							Image(systemName: "checkmark")
						}
					}
				}
				.foregroundColor(Color("textColor"))
			}
		}
		.navigationBarBackButtonHidden()
		.navigationBarTitle("언어 설정", displayMode: .inline)
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

struct ProfileLanguageView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ProfileLanguageView()
		}
	}
}
