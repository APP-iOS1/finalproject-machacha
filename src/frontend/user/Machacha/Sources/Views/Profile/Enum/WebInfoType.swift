//
//  WebInfoType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation
import SwiftUI

enum WebInfoType: Hashable {
	case privacy					// 개인정보 이용약관
	case openSource					// 오픈소스
	case license					// 라이센스
	
	// display text
	var display: String {
		switch self {
		case .privacy:
			return "개인정보 이용약관"
		case .openSource:
			return "오픈소스 라이브러리"
		case .license:
			return "라이센스"
		}
	}
	
	// url 주소
	var url: String {
		switch self {
		case .privacy:
			return "https://glacier-bucket-5c2.notion.site/17a3bda8c13c4bed96dd47049af958cb"
		case .openSource:
			return "https://glacier-bucket-5c2.notion.site/97fd3519c1ca4bd98201a6dbc208b58e"
		case .license:
			return "https://glacier-bucket-5c2.notion.site/2a9494a4a8b94980a8d9691878da2ded"
		}
	}
	
	// System Image
	var image: String {
		switch self {
		case .privacy:
			return "lock.shield"
		case .openSource:
			return "square.stack.3d.up"
		case .license:
			return "rosette"
		}
	}
	
	// Image badge
	var badge: String {
		switch self {
		case .license:
			return "checkmark"
		default:
			return ""
		}
	}
}
