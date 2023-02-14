//
//  Report.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/14.
//

import Foundation

struct Report: Identifiable {
	let id: String
	let targetId: String 	//foodCart, Review Id
	let userId: String
	let type: Int 			// 0이 가게, 1이 리뷰
	let content: [Bool]
	let etc: String
	let createdAt: Date
	
	static func getDummy() -> Self {
		return Report(id: UUID().uuidString, targetId: "84C78DA2-BA70-4319-B7DC-FEB45EB79913", userId: "egmqxtTT1Zani0UkJpUW", type: 1, content: [false, true, false, false, false, true], etc: "떡볶이 가게 홍보문구 리뷰 너무 불편하네요..속아서 먹었더니 맛도 없고..", createdAt: Date())
	}
}
