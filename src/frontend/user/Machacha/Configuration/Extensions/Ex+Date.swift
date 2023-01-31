//
//  Ex+Date.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import Foundation

extension Date {
    // MARK: - 입력받은 date를 일 (11일 or 15일)로 변환하는 메소드
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        
        return dateFormatter.string(from: self)
    }
}
