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
            DispatchQueue.main.async {
                self.foodCarts.removeAll()
            }

            let querysnapshot = try await database.collection("FoodCart")
                .getDocuments()

            for document in querysnapshot.documents {
                let data = document.data()

                let id = data["id"] as? String ?? ""
                let name: String = data["name"] as? String ?? ""
                let region: String = data["region"] as? String ?? ""
                let address: String = data["address"] as? String ?? ""
                let geoPoint: GeoPoint = data["geoPoint"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
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
                let updatedAt: Timestamp = data["updatedAt"] as? Timestamp ?? Timestamp()
                let createdAt: Timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
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
	
	// MARK: - 서버에서 FoodCart Collection의 데이터들을 불러오는 Method
	func fetchFoodCartByFoodCartId(_ foodcartId: String) async -> FoodCart {
		var foodCart = FoodCart.getDummy()
		
		do {
			let querySnapshot = try await database.collection("FoodCart")
				.document(foodcartId).getDocument()
			
			let data = querySnapshot.data()!
			
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
			
			foodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)
		} catch {
			print("fetchFoodCarts error: \(error.localizedDescription)")
		}
		return foodCart
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
    
    // MARK: - 서버에 RegisterView에서 입력한 가게정보 데이터들을 쓰는 Method
    func addFoodCart(_ foodCart: FoodCart) {
        database.collection("FoodCart")
            .document(foodCart.id)
            .setData(["id": foodCart.id,
                      "name": foodCart.name,
                      "address": foodCart.address,
                      "region": foodCart.region,
                      "geoPoint": foodCart.geoPoint,
                      "visitedCnt": foodCart.visitedCnt,
                      "favoriteCnt": foodCart.favoriteCnt,
                      "paymentOpt": foodCart.paymentOpt,
                      "openingDays": foodCart.openingDays,
                      "menu": foodCart.menu,
                      "bestMenu": foodCart.bestMenu,
                      "imageId": foodCart.imageId,
                      "grade": foodCart.grade,
                      "reportCnt": foodCart.reportCnt,
                      "reviewId": foodCart.reviewId,
                      "registerId": foodCart.registerId,
                      "updatedAt": foodCart.updatedAt,
                      "createdAt": foodCart.createdAt
                     ])
    }
    
    // MARK: - 서버에서 가게에 따른 사용자 '좋아요' 데이터들 수정하는 Method
    func fetchFavorite(isFavorited: Bool, user: User, foodCartId: String) async {
        let deleteFoodCart = user.favoriteId.filter { $0 != foodCartId } //배열에서 푸드카드 아이디를 삭제해주는 변수

        do {
            if isFavorited {
                try await database.collection("User")
                    .document(user.id)
                    .updateData([
                        "favoriteId": deleteFoodCart + [foodCartId]])
            } else {
                try await database.collection("User")
                    .document(user.id)
                    .updateData([
                        "favoriteId": deleteFoodCart])
            }
        } catch {
            print("fetchFavorite error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 해당 FoodCart의 '좋아요' 유무를 불러오는 Method
    func fetchUserFavoriteFoodCart(userId: String, foodCartId: String) async throws -> Bool {
        var user: User // 비동기 통신으로 받아올 Property
        
        let userSnapshot = try await database.collection("User").document(userId).getDocument() // 첫번째 비동기 통신
        let docData = userSnapshot.data()!
        
        let id: String = docData["id"] as? String ?? ""
        let isFirstLogin: Bool = docData["isFirstLogin"] as? Bool ?? false
        let email: String = docData["email"] as? String ?? ""
        let name: String = docData["name"] as? String ?? ""
        let profileId: String = docData["profileId"] as? String ?? ""
        let favoriteId: [String] = docData["favoriteId"] as? [String] ?? []
        let visitedId: [String] = docData["visitedId"] as? [String] ?? []
        let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
        let createdAt: Timestamp = docData["createdAt"] as! Timestamp

        user = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())

        return user.favoriteId.contains(foodCartId)
    }
    
    // MARK: - 서버에서 가게에 따른 사용자 '가봤어요' 데이터들 수정하는 Method
    func fetchVisited(isVisited: Bool, user: User, foodCartId: String) async {
        let deleteFoodCart = user.visitedId.filter { $0 != foodCartId } //배열에서 푸드카드 아이디를 삭제해주는 변수
        
        do {
            if isVisited {
                try await database.collection("User")
                    .document(user.id)
                    .updateData([
                        "visitedId": deleteFoodCart + [foodCartId]])
            } else {
                try await database.collection("User")
                    .document(user.id)
                    .updateData([
                        "visitedId": deleteFoodCart])
            }
        } catch {
            print("fetchVisited error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 해당 FoodCart의 '가봤어요' 유무를 불러오는 Method
    func fetchUserVisitedFoodCart(userId: String, foodCartId: String) async throws -> Bool {
        var user: User // 비동기 통신으로 받아올 Property
        
        let userSnapshot = try await database.collection("User").document(userId).getDocument() // 첫번째 비동기 통신
        let docData = userSnapshot.data()!
        
        let id: String = docData["id"] as? String ?? ""
        let isFirstLogin: Bool = docData["isFirstLogin"] as? Bool ?? false
        let email: String = docData["email"] as? String ?? ""
        let name: String = docData["name"] as? String ?? ""
        let profileId: String = docData["profileId"] as? String ?? ""
        let favoriteId: [String] = docData["favoriteId"] as? [String] ?? []
        let visitedId: [String] = docData["visitedId"] as? [String] ?? []
        let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
        let createdAt: Timestamp = docData["createdAt"] as! Timestamp

        user = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())

        return user.visitedId.contains(foodCartId)
    }
}

