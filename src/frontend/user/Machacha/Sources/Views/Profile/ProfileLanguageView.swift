//
//  ProfileLanguageView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/04.
//

import SwiftUI

struct ProfileLanguageView: View {
	//MARK: Property wrapper
	@AppStorage("selectedLanguage") private var selectedLanguage: String?
	@Environment(\.presentationMode) var presentation

	//MARK: Property
	let languageDict: [String: String] = ["한국어": "Korean", "중국어": "Chinese"]

	var body: some View {
		List {
			ForEach(Array(languageDict.keys), id: \.self) { language in
				Button {
					self.selectedLanguage = languageDict[language]
					//						showingOptions.toggle()
				} label: {
					HStack {
						Text(LocalizedStringKey(language))
						Spacer()
						if selectedLanguage == language {
							Image(systemName: "checkmark")
						}
					}
				}
				.foregroundColor(Color("textColor"))
				//					.confirmationDialog("언어설정을 바꾼뒤 앱을 재가동해야합니다. 선택된 언어로 바꾸시겠습니까?", isPresented: $showingOptions, titleVisibility: .visible) {
				//						Button("변경") {
				//							defaultLanguage = selectedLanguage ?? ""
				//							UserDefaults.standard.set([defaultLanguage], forKey: "AppleLanguages")
				//							//이코드 누가 씀...? 질문질문
				//							UIApplication.shared.requestSceneSessionActivation(nil, userActivity: nil, options: nil, errorHandler: nil)
				//						}
				//					}
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
