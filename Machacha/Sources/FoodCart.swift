//
//  FoodCart.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import Foundation

struct FoodCart: Identifiable {
    let id: String
    let name: String            // 포장마차 이름
    let type: String            // 포장마차 타입 ex) 분식, 타코야끼, 닭꼬치 등
    let coordinate: [Double]    // 포장마차의 좌표
}

let foodCartDummy = [
    FoodCart(id: UUID().uuidString, name: "마차킹", type: "분식", coordinate: [37.566249, 126.992227]),
    FoodCart(id: UUID().uuidString, name: "마차퀸", type: "타코야끼", coordinate: [37.560840, 126.986418]),
]
