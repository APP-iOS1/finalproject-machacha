//
//  FoodCart.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import Foundation
import FirebaseFirestore

struct FoodCart: Identifiable, Equatable {
    let id: String
    let createdAt: Date    		// 가게가 등록된 시간
    let updatedAt: Date		    // 가게의 정보가 업데이트된 시간
    let geoPoint: GeoPoint      // 가게의 실제 좌표
    let region: String          // 동기준 ex) 명동, 을지로동
    let name: String            // 사용자가 등록할 포장마차의 이름
    let address: String         // 포장마차의 실제 위치
    let visitedCnt: Int         // 가게를 방문한 총 유저 수
    let favoriteCnt: Int        // 가게를 즐겨찾기로 등로한 유저 수
    let paymentOpt: [Bool]    	// [현금, 계좌이체, 카드]
    let openingDays: [Bool]     // [월, 화, 수, 목, 금, 토, 일] 오픈한 날은 true로 바꿔줌
    let menu: [String: Int]     // 메뉴 Ex(붕어빵: 3000)
    let bestMenu: Int           // 아이콘을 위한 변수
    let imageId: [String]       // storage image
    let grade: Double           // 가게의 평점
    let reportCnt: Int          // 가게가 신고된 횟수
    let reviewId: [String]      // 가게에 대한 리뷰 정보
    let registerId: String		// 등록한 유저
    var gradeRounded: String {
      return String(format: "%.1f", grade)
    }
	
    var markerImage: String {
        switch bestMenu {
        case 0:
            return "bbungbread2"
        case 1:
            return "fishcake2"
        case 2:
            return "sweetpotato2"
        case 3:
            return "tteokboki2"
        case 4:
            return "takoyaki"
        case 5:
            return "hotteok"
        case 6:
            return "skewers"
        case 7:
            return "dessert"
        case 8:
            return "beverage"
        default:
            return "store2"
        }
    }
    
    static func getDummy() -> Self {
        return FoodCart(id: "CE3AF1BA-E63C-4C9B-B96C-B289626152EA", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.566249, longitude: 126.992227), region: "명동구", name: "ABC 앞 떡볶이", address: "서울특별시 중구 명동10길 29", visitedCnt: 14, favoriteCnt: 53, paymentOpt: [true, true, true], openingDays: [false, true, false, true, true, true, true], menu: ["떡볶이":5000, "어묵":2000, "빨간 어묵":2000], bestMenu: 0, imageId: ["IMG_2468.HEIC", "IMG_2470.HEIC", "IMG_4837.HEIC", "IMG_9431.HEIC", "IMG_9432.HEIC", "IMG_9447.HEIC"], grade: 4.2, reportCnt: 0, reviewId: ["248E538A-15CF-4E65-938B-21FD59059602", " tMa78vORR05hLmDXRojl"], registerId: "egmqxtTT1Zani0UkJpUW")
    }
    
    static func getListDummy() -> [Self] {
        return [
            FoodCart(id: "InzqNwgl15TytWNOdIZz", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.566249, longitude: 126.992227), region: "명동구", name: "마차챠차차차1", address: "서울시 xx구 xx동 번지", visitedCnt: 21, favoriteCnt: 10, paymentOpt: [true, true, false], openingDays: [false, false, false, false, false, true, true], menu: ["붕어빵":1000, "떡볶이":2500], bestMenu: 3, imageId: ["test"], grade: 3.2, reportCnt: 0, reviewId: ["qsPzae844YI3jljYVoaT"], registerId: "egmqxtTT1Zani0UkJpUW"),
            FoodCart(id: "InzqNwgl15TytWNOdIZz1", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.561840, longitude: 126.986418), region: "명동구", name: "마차챠잇2", address: "서울시 xx구 xx동 번지", visitedCnt: 32, favoriteCnt: 13, paymentOpt: [true, true, false], openingDays: [true, false, true, false, false, true, true], menu: ["붕어빵":2000, "떡볶이":5500], bestMenu: 0, imageId: ["test"], grade: 3.2, reportCnt: 0, reviewId: ["qsPzae844YI3jljYVoaT1"], registerId: "egmqxtTT1Zani0UkJpUW"),
            FoodCart(id: "InzqNwgl15TytWNOdIZz2", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.560840, longitude: 126.986418), region: "명동구", name: "마차챠잇3", address: "서울시 xx구 xx동 번지", visitedCnt: 32, favoriteCnt: 13, paymentOpt: [true, true, false], openingDays: [true, false, true, false, false, true, true], menu: ["붕어빵":2000, "떡볶이":5500], bestMenu: 1, imageId: ["test"], grade: 3.2, reportCnt: 0, reviewId: ["qsPzae844YI3jljYVoaT2"], registerId: "egmqxtTT1Zani0UkJpUW"),
            FoodCart(id: "InzqNwgl15TytWNOdIZz3", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.560840, longitude: 126.987418), region: "명동구", name: "마차챠잇4", address: "서울시 xx구 xx동 번지", visitedCnt: 32, favoriteCnt: 13, paymentOpt: [true, true, false], openingDays: [true, false, true, false, false, true, true], menu: ["붕어빵":2000, "떡볶이":5500], bestMenu: 2, imageId: ["test"], grade: 3.2, reportCnt: 0, reviewId: ["qsPzae844YI3jljYVoaT3"], registerId: "egmqxtTT1Zani0UkJpUW")
        ]
    }
}
