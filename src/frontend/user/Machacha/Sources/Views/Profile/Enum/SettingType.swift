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
			return "FaceID"
		case .alert:
			return "알림"
		case .darkMode:
			return "다크모드"
		case .language:
			return "언어"
		}
	}

	// System Image
	var image: String {
		switch self {
		case .faceID:
			return "faceid"
		case .alert:
			return "bell"
		case .darkMode:
			return "gearshape"
		case .language:
			return "globe"
		}
	}
}
