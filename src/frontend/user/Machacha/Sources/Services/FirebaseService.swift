//
//  FirebaseService.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/02/04.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct FirebaseService {
    static let db = Firestore.firestore()
    
    
    static func fetchFoodCarts() -> AnyPublisher<[FoodCart], Error>  {
        Future<[FoodCart], Error> { promise in
            db.collection("FoodCart")
                .getDocuments {snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        promise(.failure(FirebaseError.badsnapshot))
                        return
                    }
                    
                    var foodCarts: [FoodCart] = []
                    snapshot.documents.forEach { document in
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
                        let paymentOpt: [Bool] = data["isPaymentOpt"] as? [Bool] ?? []
                        let openingDays: [Bool] = data["openingDays"] as? [Bool] ?? []
                        let reviewId: [String] = data["reviewId"] as? [String] ?? []
                        let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                        let createdAt: Timestamp = data["createdAt"] as! Timestamp
                        let registerId: String = data["registerId"] as? String ?? ""
                    
                        
                        let foodCart: FoodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)
                        foodCarts.append(foodCart)
                    }
                    
                    promise(.success(foodCarts))
                }
        }
        .eraseToAnyPublisher()
    }
}
