//
//  FoodCartViewModel.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class FoodCartViewModel: ObservableObject {
    
    @Published var foodCarts: [FoodCart] = []
    @Published var imageDict: [String : UIImage] = [:]
    @Published var isLoading: Bool = false
    @Published var isShowingReportSheet = false
    @Published var isShowingReviewSheet = false

    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    // MARK: - 서버에서 FoodCart Collection의 데이터들을 불러오는 Method
//    func fetchFoodCarts() {
//        database.collection("FoodCart")
//            .getDocuments { (snapshot, error) in
//                self.foodCarts.removeAll()
//                self.imageDict.removeAll()
//
//                if let snapshot {
//                    for document in snapshot.documents {
//                        let id: String = document.documentID
//
//                        let docData = document.data()
//                        let name: String = docData["name"] as? String ?? ""
//                        let region: String = docData["region"] as? String ?? ""
//                        let address: String = docData["address"] as? String ?? ""
//                        let geoPoint: GeoPoint = docData["geoPoint"] as! GeoPoint
//                        let imageId: [String] = docData["imageId"] as? [String] ?? []
//                        let grade: Double = docData["grade"] as? Double ?? 0
//                        let visitedCnt: Int = docData["visitedCnt"] as? Int ?? 0
//                        let favoriteCnt: Int = docData["favoriteCnt"] as? Int ?? 0
//                        let reportCnt: Int = docData["reportCnt"] as? Int ?? 0
//                        let menu: [String: Int] = docData["menu"] as? [String: Int] ?? [:]
//                        let bestMenu: Int = docData["bestMenu"] as? Int ?? 0
//                        let paymentOpt: [Bool] = docData["paymentOpt"] as? [Bool] ?? []
//                        let openingDays: [Bool] = docData["openingDays"] as? [Bool] ?? []
//                        let reviewId: [String] = docData["reviewId"] as? [String] ?? []
//                        let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
//                        let createdAt: Timestamp = docData["createdAt"] as! Timestamp
//
//
//
//                        // fetch image set
//                        for imageName in imageId {
//                            self.fetchImage(foodCartId: id, imageName: imageName)
//                        }
//
//                        let foodCart: FoodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId)
//
//                        self.foodCarts.append(foodCart)
//                    }
//                }
//            }
//    }
    
    
    // MARK: - 서버에서 FoodCart Collection의 데이터들을 불러오는 Method
    @MainActor
    func fetchFoodCarts() async {
        do {
            let querysnapshot = try await database.collection("FoodCart")
                .getDocuments()

            for document in querysnapshot.documents {
                let data = document.data()

                let id = data["id"] as? String ?? ""
                let name: String = data["name"] as? String ?? ""
                let region: String = data["region"] as? String ?? ""
                let address: String = data["address"] as? String ?? ""
                let geoPoint: GeoPoint = data["geoPoint"] as! GeoPoint
                let imageId: [String] = data["imageId"] as? [String] ?? []
                let grade: Double = data["grade"] as? Double ?? 0
                let visitedCnt: Int = data["visitedCnt"] as? Int ?? 0
                let favoriteCnt: Int = data["favoriteCnt"] as? Int ?? 0
                let reportCnt: Int = data["reportCnt"] as? Int ?? 0
                let menu: [String: Int] = data["menu"] as? [String: Int] ?? [:]
                let bestMenu: Int = data["bestMenu"] as? Int ?? 0
                let paymentOpt: [Bool] = data["paymentOpt"] as? [Bool] ?? []
                let openingDays: [Bool] = data["openingDays"] as? [Bool] ?? []
                let reviewId: [String] = data["reviewId"] as? [String] ?? []
                let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                let createdAt: Timestamp = data["createdAt"] as! Timestamp
                let registerId: String = data["registerId"] as? String ?? ""

                // fetch image set
                for imageName in imageId {
                    self.fetchImage(foodCartId: id, imageName: imageName)
                }

                let foodCart: FoodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)

                foodCarts.append(foodCart)
            }
        } catch {
            print("fetchFoodCarts error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func fetchImage(foodCartId: String, imageName: String) {
        let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("foodcart image error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.imageDict[imageName] = image
            }
        }
    }
}

