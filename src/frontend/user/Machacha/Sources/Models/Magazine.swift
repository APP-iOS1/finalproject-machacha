//
//  Magazine.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/20.
//

import Foundation

struct Magazine {
	let id: String
	let foodCartId: [String]        // foodCart들의 id
	let pickTitle: String           // ~~~'s PICK
	let title: String               // Main Title
	let subTitle: String            // SubTitle
	let comment: String             // 큐레이터의 한마디
	let thumbnail: String           // 매거진의 Main Image, storageId
	let updatedAt: Date
	let createdAt: Date
	
	static func getDummy() -> Self {
		return Magazine(id: "9HYoFd0JG8ZPqVbDNSwE", foodCartId: ["InzqNwgl15TytWNOdIZz"], pickTitle: "겨울이 좋은 마챠차's PICK", title: "만원으로 명동을 돌아보기", subTitle: "명동의 간식 포장마차를 찾아 떠난 지방러", comment: "지방러들을 위해 명동의 간식 포장마차를 대신 다녀왔습니다. 행복했던 시간을 기록해 봅니다.", thumbnail: "test", updatedAt: Date(), createdAt: Date())
	}
}
