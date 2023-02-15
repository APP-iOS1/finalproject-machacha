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
	@Published var report: [Report] = [] // 신고 기록
	@Published var reportFoodCart: [Report] = [] // 가게 신고 기록
	@Published var reportReview: [Report] = [] // 리뷰 신고 기록
	
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
	
	// MARK: - 서버에서 Report의 데이터들을 불러오는 Method
	func fetchReports() async -> [Report] {
		var reports = [Report]()
		
		do {
			let querysnapshot = try await database.collection("Report")
				.getDocuments()
			
			for document in querysnapshot.documents {
				let data = document.data()
				
				let id = data["id"] as? String ?? ""
				let targetId: String = data["targetId"] as? String ?? ""
				let userId: String = data["userId"] as? String ?? ""
				let type: Int = data["type"] as? Int ?? 0
				let content: [Bool] = data["content"] as? [Bool] ?? []
				let etc: String = data["etc"] as? String ?? ""
				let createdAt: Timestamp = data["createdAt"] as! Timestamp
				
				let report: Report = Report(id: id, targetId: targetId, userId: userId, type: type, content: content, etc: etc, createdAt: createdAt.dateValue())
				
				reports.append(report)
			}
		} catch {
			print("fetchFoodCarts error: \(error.localizedDescription)")
		}
		
		return reports.sorted{$0.createdAt > $1.createdAt}
	}
	
	// MARK: - 서버에서 가게에 맞는 FoodCart Collection의 데이터을 불러오는 Method
	func fetchFoodCart(foodCartId: String) async -> FoodCart {
		var foodCart: FoodCart = FoodCart.getDummy()
		
		do {
			let querysnapshot = try await database.collection("FoodCart")
				.document(foodCartId).getDocument()
			
			let data = querysnapshot.data()!
			
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
			
			foodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)
		} catch {
			print("fetchReviews error: \(error.localizedDescription)")
		}
		return foodCart
	}
	
	// MARK: - 서버에서 가게에 맞는 Review Collection의 데이터들을 불러오는 Method
	func fetchReviews(reviewId: String) async -> Review {
		var review: Review = Review.getDummy1()
		
		do {
			let querysnapshot = try await database.collection("Review")
				.document(reviewId).getDocument()
			
			let data = querysnapshot.data()!
			
			let id = data["id"] as? String ?? ""
			let reviewer: String = data["reviewer"] as? String ?? ""
			let foodCartId: String = data["foodCartId"] as? String ?? ""
			let grade: Double = data["grade"] as? Double ?? 0
			let description: String = data["description"] as? String ?? ""
			let imageId: [String] = data["imageId"] as? [String] ?? []
			let updatedAt: Timestamp = data["updatedAt"] as? Timestamp ?? Timestamp()
			let createdAt: Timestamp = data["createdAt"] as? Timestamp ?? Timestamp()
			
			review = Review(id: id, reviewer: reviewer, foodCartId: foodCartId, grade: grade, description: description, imageId: imageId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())
		} catch {
			print("fetchReviews error: \(error.localizedDescription)")
		}
		return review
	}
	
	// MARK: - 서버에서 User의 데이터들을 불러오는 Method
	func fetchReviews(userId: String) async -> (String, String) {
		var userData: (String, String) = ("", "")
		
		do {
			let userSnapshot = try await database.collection("User").document(userId).getDocument() // 첫번째 비동기 통신

			let docData = userSnapshot.data()!
			
			let name: String = docData["name"] as? String ?? ""
			let profileId: String = docData["profileId"] as? String ?? ""

			userData = (name, profileId)
		} catch {
			print("fetchReviews error: \(error.localizedDescription)")
		}
		return userData
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
		
		return UIImage(data: data) ?? UIImage()
	}
}
