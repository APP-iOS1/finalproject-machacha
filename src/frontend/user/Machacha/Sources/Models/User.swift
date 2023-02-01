//
//  User.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation

struct User: Identifiable {
	let id: String
	var isFirstLogin: Bool      // 최초 로그인 여부
	let email: String
	var name: String            // 사용자가 회원가입 시 등록한 이름
	var profileId: String       // 유저의 프로필 사진
	var favoriteId: [String]    // 즐겨찾기한 foodCart id
	var visitedId: [String]     // 내가 가본 foodCart id
	var updatedAt: Date
	let createdAt: Date
	
	static func getDummy() -> Self {
		return User(id: "egmqxtTT1Zani0UkJpUW", isFirstLogin: false, email: "test@gmail.com", name: "마차킹", profileId: "test", favoriteId: ["InzqNwgl15TytWNOdIZz"], visitedId: ["InzqNwgl15TytWNOdIZz"], updatedAt: Date(), createdAt: Date())
	}
}
