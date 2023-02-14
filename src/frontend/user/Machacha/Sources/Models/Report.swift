//
//  Report.swift
//  Machacha
//
//  Created by 이지연 on 2023/02/13.
//

import Foundation

struct Report: Identifiable {
    let id: String
    let targetId: String //foodCart, Review Id
    let userId: String
    let type: Int // 0이 가게, 1이 리뷰
    let content: [Bool]
    let etc: String
    let createdAt: Date
}
