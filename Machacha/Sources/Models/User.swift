//
//  User.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation

struct User {
	let id: String
	let isFirstLogin: Bool      // 최초 로그인 여부
	let email: String
	let name: String            // 사용자가 회원가입 시 등록한 이름
	let profileId: String       // 유저의 프로필 사진
	let favoriteId: [String]    // 즐겨찾기한 foodCart id
	let visitedId: [String]     // 내가 가본 foodCart id
	let updatedAt: Date
	let createdAt: Date
	
	static func getDummy() -> Self {
		return User(id: "egmqxtTT1Zani0UkJpUW", isFirstLogin: false, email: "test@gmail.com", name: "마차킹", profileId: "test", favoriteId: ["InzqNwgl15TytWNOdIZz"], visitedId: ["InzqNwgl15TytWNOdIZz"], updatedAt: Date(), createdAt: Date())
	}
}
