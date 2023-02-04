//
//  LanguageType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import Foundation

enum LanguageType: String {
	case korean = "ko"
	case chinese_simplified = "zh-Hans"
	
	var userSymbol: String {
		switch self {
		default:
			return rawValue
		}
	}
}
