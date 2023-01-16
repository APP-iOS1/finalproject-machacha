//
//  Ex+String.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation

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
}
