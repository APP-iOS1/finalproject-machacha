//
//  ReportViewModel.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/13.
//

import UIKit
import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class ReportViewModel: ObservableObject {
	//MARK: Property Wrapper
	@Published var reportFoodCarts: [FoodCart] = [] // 사용자가 3회 이상 신고한 FoodCart
	
	//MARK: Property
	private let database = Firestore.firestore()
	private let storage = Storage.storage()

	// MARK: - 서버에서 FoodCart Collection의 데이터들을 불러오는 Method
	func fetchFoodCarts() async -> [FoodCart] {
		var foodCarts = [FoodCart]()
		
		do {
			let querysnapshot = try await database.collection("FoodCart").whereField("reportCnt", isGreaterThan: 2)
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
		return foodCarts.sorted{$0.updatedAt > $1.updatedAt}
	}
	
	// MARK: - 서버의 Storage에서 이미지를 가져오는 Method
	func fetchImage(foodCartId: String, imageName: String) async -> UIImage {
		var data = Data()
		
		do {
			let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
			data = try await ref.data(maxSize: 1 * 1024 * 1024)
			
		} catch {
			print("fetchImage error: \(error.localizedDescription)")
		}
		
		return UIImage(data: data)!
	}
}
