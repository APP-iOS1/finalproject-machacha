//
//  MagazineViewModel.swift
//  Machacha
//
//  Created by Sue on 2023/02/01.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
//import UIKit
import Kingfisher


struct FoodCart2: Identifiable, Equatable {
    let id: String
    let createdAt: Date            // 가게가 등록된 시간
    let updatedAt: Date            // 가게의 정보가 업데이트된 시간
    let geoPoint: GeoPoint      // 가게의 실제 좌표
    let region: String          // 동기준 ex) 명동, 을지로동
    let name: String            // 사용자가 등록할 포장마차의 이름
    let address: String         // 포장마차의 실제 위치
    let visitedCnt: Int         // 가게를 방문한 총 유저 수
    let favoriteCnt: Int        // 가게를 즐겨찾기로 등로한 유저 수
    let paymentOpt: [Bool]        // [현금, 계좌이체, 카드]
    let openingDays: [Bool]     // [월, 화, 수, 목, 금, 토, 일] 오픈한 날은 true로 바꿔줌
    let menu: [String: Int]     // 메뉴 Ex(붕어빵: 3000)
    let bestMenu: Int           // 아이콘을 위한 변수
    let imageId: [String]       // storage image
    let grade: Double           // 가게의 평점
    let reportCnt: Int          // 가게가 신고된 횟수
    let reviewId: [String]      // 가게에 대한 리뷰 정보
    let registerId: String        // 등록한 유저
    let url: [String] //이미지 경로 저장
}


class MagazineViewModel: ObservableObject {
    
    @Published var magazines: [Magazine] = []
    @Published var magazineFoodCart: [FoodCart2] = []
//    @Published var imageDict: [String : String] = [:] // IMG_4842.HEIC" : "사진 경로"
    @Published var isLoading = false
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    func fetchMagazines() async throws -> [Magazine] {
        var magazines = [Magazine]()
        
        let magazineSnapshot = try await  database.collection("Magazine").getDocuments()
        
        for magazine in magazineSnapshot.documents {
            let docData = magazine.data()
            
            let id: String = docData["id"] as? String ?? ""
            let title: String = docData["title"] as? String ?? ""
            let subtitle: String = docData["subtitle"] as? String ?? ""
            let editorPickTitle: String = docData["editorPickTitle"] as? String ?? ""
            let editorCommemt: String = docData["editorCommemt"] as? String ?? ""
            let image: String = docData["image"] as? String ?? ""
            let background: String = docData["background"] as? String ?? ""
            let foodCartIds: [String] = docData["foodCartId"] as? [String] ?? []
            let createdAt: Timestamp = docData["createdAt"] as! Timestamp
            let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
            
            magazines.append(Magazine(id: id, title: title, subtitle: subtitle, editorPickTitle: editorPickTitle, editorCommemt: editorCommemt, image: image, background: background, foodCartId: foodCartIds, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue()))
            
        }
        print("fetched Magazines: \(magazines)")
        return magazines
    }
    
    
    // ["dkfjls", "dfsldf", "delske"]
    
    func fetchFoodCarts(foodCartIds: [String]) async throws -> [FoodCart2] {
        var foodcarts = [FoodCart2]()
        
        for foodcartID in foodCartIds {
            let foodcartSnapshot = try await database.collection("FoodCart").document(foodcartID).getDocument() //하나의 푸드카드 불러옴
            
            guard let docData = foodcartSnapshot.data() else {return [] }
            
            let id: String = docData["id"] as? String ?? ""
            let region: String = docData["region"] as? String ?? ""
            let name: String = docData["name"] as? String ?? ""
            let address: String = docData["address"] as? String ?? ""
            let visitedCnt: Int = docData["visitedCnt"] as? Int ?? 0
            let favoriteCnt: Int = docData["favoriteCnt"] as? Int ?? 0
            let paymentOpt: [Bool] = docData["paymentOpt"] as? [Bool] ?? []
            let openingDays: [Bool] = docData["openingDays"] as? [Bool] ?? []
            let menu: [String: Int] = docData["menu"] as? [String: Int] ?? [:]
            let bestMenu: Int = docData["bestMenu"] as? Int ?? 0
            let imageId: [String] = docData["imageId"] as? [String] ?? []
            let grade: Double = docData["grade"] as? Double ?? 0.0
            let reportCnt: Int = docData["reportCnt"] as? Int ?? 0
            let reviewId: [String] = docData["reviewId"] as? [String] ?? []
            let registerId: String = docData["registerId"] as? String ?? ""
            let geoPoint: GeoPoint = docData["geoPoint"] as! GeoPoint
            let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
            let createdAt: Timestamp = docData["createdAt"] as! Timestamp
            var url = [String]()
            
            //imageID : ["IMG_4828.HEIC"]
            for imageName in imageId {
                let url1 = try await self.fetchImage(foodCartId: id, imageName: imageName) // imageName : "IMG_4828.HEIC"
                url.append(url1) //[String]
            }
            
            url = Array(url.reversed())
            
            foodcarts.append(FoodCart2(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId, url: url))
            
            // foodCarts는 일단 [FoodCart2]
            // FoodCart2: 하나의 가게에 해당하는 이미지 주소(String)들이 url에 들어있음
            
        }
        
        return foodcarts
    }
    
    func fetchImage(foodCartId: String, imageName: String ) async throws -> String {
        do {
            print("foodCartId: \(foodCartId)")
            print("1")
            let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
            print("2")
            let url = try await ref.downloadURL()
            print("3")
            return "\(url)"
        } catch {
            print("Magazine fetch Image error: \(error.localizedDescription)")
        }
        
        print("4")
        return ""
    }
    
    

    
    // imageName : imageID
//    func fetchImage1(foodCartId: String, imageName: String) {
//        let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("매거진 error while downloading image\n\(error.localizedDescription)")
//                return
//            } else {
//                let image = UIImage(data: data!)
//                self.imageDict[imageName] = image
//                // imageDict[test.jpg] = UIImage
//            }
//        }
//    }
    
    
    
//    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
//    func fetchImage(foodCartId: String, imageName: String) async throws -> UIImage {
//        do {
//            let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
//
//            let data = try await ref.data(maxSize: 1 * 1024 * 1024)
//
//            return UIImage(data: data)!
//        } catch {
//            print("fetchFoodCarts error: \(error.localizedDescription)")
//        }
//    }
}
