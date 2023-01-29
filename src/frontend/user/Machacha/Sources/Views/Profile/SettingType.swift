//
//  SettingType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation
import SwiftUI

enum SettingType: Hashable {
	case faceID					// faceID
	case alert					// 알림
	case darkMode				// 다크모드 전환
	case language				// 언어 전환

	// display text
	var display: String {
		switch self {
		case .faceID:
			return "Face ID"
		case .alert:
			return "알림"
		case .darkMode:
			return "다크모드"
		case .language:
			return "언어"
		}
	}
	
	// NavigationLink or Toggle
	var isToggle: Bool {
		switch self {
		case .faceID:
			return true
		case .alert:
			return true
		case .darkMode:
			return true
		case .language:
			return false
		}
	}
}
