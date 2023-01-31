//
//  FoodCartOfUserType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/26.
//

import Foundation
import SwiftUI

enum FoodCartOfUserType: Hashable {
	case favorite				// 즐겨찾기
	case review					// 내가 쓴 리뷰
	case visited				// 가봤어요
	case register				// 등록한 포장마차

	// display text
	var display: String {
		switch self {
		case .favorite:
			return "즐겨찾기"
		case .review:
			return "리뷰관리"
		case .visited:
			return "가봤어요"
		case .register:
			return "등록한곳"
		}
	}
	
	// NavigationLink or Toggle
	var image: String {
		switch self {
		case .favorite:
			return "heart.fill"
		case .review:
			return "square.and.pencil"
		case .visited:
			return "checkmark.seal.fill"
		case .register:
			return "person.fill.badge.plus"
		}
	}
}
