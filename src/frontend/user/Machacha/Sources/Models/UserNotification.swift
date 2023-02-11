//
//  UserNotification.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import Foundation

struct UserNotification: Hashable, Identifiable {
	let id: String
	let userId: [String]			// 알림을 받을 유저
	var navigationType: String		// all, home, search, magazine
	var title: String				// 공지사항 제목, 나머지 type은 ""
	var contents: String			// 표출될 내용
	var updatedAt: Date
	let createdAt: Date
	
	// 시간 차이로 나타내기
	var descriptionDate: String {
		let diff = Date().timeIntervalSince(createdAt)
		
		switch diff {
		case 0..<60:
			return "방금 전"
		case 60..<3600:
			return "\(Int(diff/60))분 전"
		case 3600..<86400: // 24시간 이전
			return "\(Int(diff/3600))시간 전"
		case 86400..<604800: // 이번주 내
			return "\(Int(diff/86400))일 전"
		case 604800..<2592000:
			return createdAt.getDay(format: "dd일")
		default:
			return createdAt.getDay(format: "MM월")
		}
	}
	
	var getIntervalTime: Int {
		let diff = Date().timeIntervalSince(createdAt)
		return Int(diff)
	}
	
	static func getDummy() -> Self {
		return UserNotification(id: "0DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "all", title: "new", contents: "마차차 공지사항 내용입니다", updatedAt: Date(), createdAt: Date())
	}
	
	static func getDummyList() -> [Self] {
		return [
			UserNotification(id: "0DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "all", title: "new", contents: "이달의 공지사항", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "1DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "home", title: "new", contents: "", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "2DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "search", title: "new", contents: "", updatedAt: Date(), createdAt: Date()),
			UserNotification(id: "3DkzxCKtVprJTu1IacSw", userId: ["egmqxtTT1Zani0UkJpUW"], navigationType: "magazine", title: "new", contents: "", updatedAt: Date(), createdAt: Date())
		]
	}
}
