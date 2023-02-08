//
//  Ex+Date.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import Foundation

extension Date {
	// MARK: - 입력받은 date를 일 (11일 or 15일)로 변환하는 메소드
	func getDay() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
		
		return dateFormatter.string(from: self)
	}
	
	func getDay(format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
		
		return dateFormatter.string(from: self)
	}
	
	// 방금전, 몇초전을 나타내는 함수
	func renderTime() -> String {
		if Calendar.current.dateComponents([.day], from: self, to: .now).day! > 7 { // 기준 7일
			let formatter = DateFormatter()
			formatter.locale = Locale(identifier: "ko_KR")
			formatter.timeZone = TimeZone(abbreviation: "KST")
			formatter.amSymbol = "오전"
			formatter.pmSymbol = "오후"
			formatter.dateStyle = .long
			formatter.timeStyle = .short
			return formatter.string(from: self)
		}
		
		// 방금전, 몇초전을 나타내는 함수
		let formatter = RelativeDateTimeFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.dateTimeStyle = .named
		return formatter.localizedString(for: self, relativeTo: .now)
	}
}
