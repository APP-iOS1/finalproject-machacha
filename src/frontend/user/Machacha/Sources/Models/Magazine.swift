//
//  Magazine.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/20.
//

import Foundation

struct Magazine: Identifiable {
	let id: String
    let thumbTitle: String               // Main Title
    let thumbnail: String           // 매거진의 Main Image, storageId
    let editorPickTitle: String           // ~~~'s PICK
    let subTitle: String            // SubTitle
    let comment: String             // 큐레이터의 한마디
    let foodCartId: [String]        // foodCart들의 id
    let updatedAt: Date
    let createdAt: Date
    var show: Bool //새로 추가
    
    static func getDummy() -> Self {
        return Magazine(id: "ECch0WHCMyJN6bqzranq", thumbTitle: "붕어빵", thumbnail: "p3",  editorPickTitle: "겨울 조하's PICK", subTitle: "명동의 붕어빵을 찾아 떠난 지방러", comment: "지방러들을 위해 명동의 간식 포장마차를 대신 다녀왔습니다. 행복했던 시간을 기록해 봅니다.", foodCartId: ["InzqNwgl15TytWNOdIZz"], updatedAt: Date(), createdAt: Date(), show: false)
    }
	

}

