//
//  Review.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/20.
//

import Foundation

struct Review: Identifiable {
	let id: String
	let reviewer: String            // 리뷰쓴 사람의 userID
	let foodCartId: String          // foodCart id
	let grade: Double               // 리뷰의 평점
	let description: String         // 사용자 후기
	let imageId: [String]           // 사용자가 review 올린 사진들
	let upadtedAt: Date
	let createdAt: Date
	
	static func getDummy() -> Self {
		return Review(id: "qsPzae844YI3jljYVoaT", reviewer: "egmqxtTT1Zani0UkJpUW", foodCartId: "InzqNwgl15TytWNOdIZz", grade: 2.3, description: "사용자 후기", imageId: ["test"], upadtedAt: Date(), createdAt: Date())
	}
}
