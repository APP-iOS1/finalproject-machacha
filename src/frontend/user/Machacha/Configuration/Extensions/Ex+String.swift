//
//  Ex+String.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation
import SwiftUI

extension String {
	func toDate(fommat: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = fommat
		dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
		
		if let date = dateFormatter.date(from: self) {
			return date
		} else {
			return nil
		}
	}
	
	//이메일 마스킹 ( test12@test.com -> te**12@test.com )
	func maskEmail() -> String {
		let components = self.components(separatedBy: "@")
		
		guard let first = components.first, let last = components.last else { return self }
		
		//첫번째 자리, 두번째 자리, 마지막 앞자리, 마지막 자리만 보이게
		let mask = first.enumerated().map {
			return [0, 1, first.count - 2, first.count - 1].contains($0.offset) ? $0.element : "*"
		}
		
		return String(mask) + "@" + last
	}
}

// Localizes(현지화) 처리
extension String {
	/// Language 열거형에서 지정된 언어를 사용하여 문자열을 현지화합니다.
	/// - parameter language: 현지화된 문자열에 사용될 언어입니다.
	/// - Returns: 현지화된 문자열.
	func localized(_ language: Language) -> String {
		let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
		let bundle: Bundle
		if let path = path {
			bundle = Bundle(path: path) ?? .main
		} else {
			bundle = .main
		}
		return localized(bundle: bundle)
	}

	/// Language 열거형에서 지정된 언어를 사용하여 문자열을 현지화합니다.
	///  - Parameters:
	///  - language: 현지화된 문자열에 사용될 언어입니다.
	///  - args:  현지화된 문자열에 대해 제공된 동적 인수입니다.
	/// - Returns: 현지화된 문자열.
	func localized(_ language: Language, args arguments: CVarArg...) -> String {
		let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
		let bundle: Bundle
		if let path = path {
			bundle = Bundle(path: path) ?? .main
		} else {
			bundle = .main
		}
		return String(format: localized(bundle: bundle), arguments: arguments)
	}

	/// self를 key로 사용하여 문자열을 현지화합니다.
	/// - Parameters:
	///   - bundle: Localizable.strings 파일이 있는 bundle.
	/// - Returns: 현지화된 문자열.
	private func localized(bundle: Bundle) -> String {
		return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
	}
}
