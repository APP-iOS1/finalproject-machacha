//
//  ApproveViewModel.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import UIKit
import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class ApproveViewModel: ObservableObject {
	//MARK: Property Wrapper
	@Published var approveFoodCarts: [FoodCart] = [] // 사용자가 요청한 FoodCart
	
	//MARK: Property
	private let database = Firestore.firestore()
	private let storage = Storage.storage()
	
	// MARK: - 서버에서 FoodCart Collection의 데이터들을 불러오는 Method
	func fetchFoodCarts() async -> [FoodCart] {
		var foodCarts = [FoodCart]()
		
		do {
			let querysnapshot = try await database.collection("Admin")
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
				let paymentOpt: [Bool] = data["isPaymentOpt"] as? [Bool] ?? []
				let openingDays: [Bool] = data["openingDays"] as? [Bool] ?? []
				let reviewId: [String] = data["reviewId"] as? [String] ?? []
				let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
				let createdAt: Timestamp = data["createdAt"] as! Timestamp
				let registerId: String = data["registerId"] as? String ?? ""
				
				let foodCart: FoodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)
				
				foodCarts.append(foodCart)
			}
		} catch {
			print("fetchFoodCarts error: \(error.localizedDescription)")
		}
		return foodCarts
	}
	
	// MARK: - 서버의 Storage에서 이미지를 가져오는 Method
	func fetchImage(foodCartId: String, imageName: String) async throws -> UIImage {
		let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
		let data = try await ref.data(maxSize: 1 * 1024 * 1024)
		
		return UIImage(data: data)!
	}
	
	// MARK: - 서버에 RegisterView에서 입력한 가게정보 데이터들을 쓰는 Method
	func addFoodCart(_ foodCart: FoodCart) {
		database
			.collection("FoodCart")
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
}
