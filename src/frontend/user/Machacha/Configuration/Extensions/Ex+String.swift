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
