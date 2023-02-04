//
//  LocalizationViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import Foundation

class LocalizationViewModel {
	//MARK: Property
	static let shared = LocalizationViewModel()
	static let changedLanguage = Notification.Name("changedLanguage")

	private init() {}
	
	var language: LanguageType {
		get {
			guard let languageString = UserDefaults.standard.string(forKey: "language") else {
				return .korean
			}
			
			return LanguageType(rawValue: languageString) ?? .korean
		} set {
			if newValue != language {
				UserDefaults.standard.setValue(newValue.userSymbol, forKey: "language")
				NotificationCenter.default.post(name: LocalizationViewModel.changedLanguage, object: nil)
			}
		}
	}
}
