//
//  SettingType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation
import SwiftUI

enum SettingType: Hashable {
	case profile				// 프로필수정
	case faceID					// faceID
	case alert					// 알림
	case darkMode				// 다크모드 전환
	case language				// 언어 전환

	// display text
	var display: String {
		switch self {
		case .profile:
			return "프로필 수정"
		case .faceID:
			return "FaceID"
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
		case .profile:
			return false
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
