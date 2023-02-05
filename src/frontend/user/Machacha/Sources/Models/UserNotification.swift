//
//  UserNotification.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import Foundation

struct UserNotification: Identifiable {
	let id: String
	let userId: [String]			// 알림을 받을 유저
	var navigationType: String		// all, home, search, magazine
	var contentType: String			// 내 근처 알림인지?
	var contents: String			// 표출될 내용
	var updatedAt: Date
	let createdAt: Date
	
	static func getDummy() -> Self {
		return UserNotification(id: "0DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "all", contentType: "전체 알림", contents: "", updatedAt: Date(), createdAt: Date())
	}
	
	static func getDummyList() -> [Self] {
		return [
			UserNotification(id: "0DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "all", contentType: "all", contents: "이달의 공지사항", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "1DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "home", contentType: "new", contents: "", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "2DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "search", contentType: "new", contents: "", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "3DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "magazine", contentType: "new", contents: "", updatedAt: Date(), createdAt: Date())
		]
	}
	
	// 추천 맛집을 알아보세요
	// 내 동내에 새로운 추가된 포장마차 발견!
	// 마차챠의 새로운 매거진 추천이 도착했습니다
}
