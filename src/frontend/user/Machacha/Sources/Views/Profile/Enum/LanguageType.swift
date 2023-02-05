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
	
	// Fagekit을 위한 code
	// 참고: https://github.com/madebybowtie/FlagKit/blob/master/Assets/Flags.md
	var flagCode: String {
		switch self {
		case .korean:
			return "KR"
		case .chinese_simplified:
			return "CN"
		}
	}
}
