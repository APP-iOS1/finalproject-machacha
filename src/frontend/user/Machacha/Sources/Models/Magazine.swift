//
//  Magazine.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/20.
//

import Foundation

struct Magazine: Identifiable {
	let id: String
    let title: String // 카드에 보이는 제목
    let subtitle: String // 카드에 보이는 부제목
    let editorPickTitle: String  // ~~~'s PICK
    let editorCommemt: String // 에디터의 간단한 카드 소개글
    let image: String // 카드에 메인 이미지
    let background: String // 카드에 배경
    let foodCartId: [String]        // foodCart들의 id
    let createdAt: Date // 카드 생성일? (필요할지는 모르겠음)
    let updatedAt: Date // 카드 수정일? (필요할지는 모르겠음)
    
    static func getDummy() -> Self {
        return Magazine(id: "CvcZaUQTF7StFGa7omZL", title: "한입 간식 : 호떡", subtitle: "명동 & 을지로 호떡 대표 맛집 TOP 3", editorPickTitle: "꿀호떡냠냠's PICK", editorCommemt: "저만의 호떡 맛집들을 공유해보려고 합니다.", image: "Illustration 1", background: "Background 1", foodCartId: ["InzqNwgl15TytWNOdIZz"], createdAt: Date(), updatedAt: Date())
    }
}

class Model: ObservableObject {
    @Published var showDetail: Bool = false
}


/*
 Course(title: "SwiftUI for iOS 15", subtitle: "20 sections - 3 hours", text: "Build an iOS app for iOS 15 with custom layouts, animation and ...", image: "Illustration 5", background: "Background 5", logo: "Logo 2")
 */
