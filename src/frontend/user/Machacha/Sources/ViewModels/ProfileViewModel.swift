//
//  ProfileViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
	//MARK: Property wrapper
	@Published var currentUser: User?
	@Published var favoriteUser: [FoodCart] = []
	@Published var reviewUser: [Review] = []
	@Published var showLogin = false			// 로그인 관리
	@Published var isFaceID: Bool = UserInfo.isFaceID {		// FaceID
		willSet { // 값이 변경되기 직전에 호출, newValue에는 새로 초기화하고자 하는 값이 들어감
			UserDefaults.standard.set(newValue, forKey: "isFaceID")
		}
	}
	@Published var isAlert: Bool = UserInfo.isAlert {			// 알림
		willSet {
			UserDefaults.standard.set(newValue, forKey: "isAlert")
		}
	}
	@Published var isDarkMode: Bool = UserInfo.isDarkMode {	// 다크모드
		willSet {
			UserDefaults.standard.set(newValue, forKey: "isDarkMode")
		}
	}
	
	//MARK: Property
	private let database = Firestore.firestore()

	init() { // 임시: 자동 로그인시 초기화 해줘야함
		UserDefaults.standard.set(false, forKey: "isFaceID")	// FaceID
		UserDefaults.standard.set(false, forKey: "isAlert")		// 알림
		UserDefaults.standard.set(false, forKey: "isDarkMode")	// 다크모드
	}
	
	// 로그아웃
	func logout() async throws {
		currentUser = nil
	}
	
	//MARK: - Read
	// User Data Fetch
	func fetchUser() async throws -> User? {
		guard let userId = UserInfo.token else { return nil }
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

		return user
	}
	
	// Reivews Data Fetch
	func fetchReivews() async throws -> [Review] {
		guard let userId = UserInfo.token else { return [] }
		var reviews = [Review]() // 비동기 통신으로 받아올 Property
		
		let reviewSnapshot = try await database.collection("Review").whereField("reviewer", isEqualTo: userId).getDocuments() // 첫번째 비동기 통신
		
		for review in reviewSnapshot.documents {
			let docData = review.data()
			
			let id: String = docData["id"] as? String ?? ""
			let reviewer: String = docData["reviewer"] as? String ?? ""
			let foodCartId: String = docData["foodCartId"] as? String ?? ""
			let grade: Double = docData["grade"] as? Double ?? 0.0
			let description: String = docData["description"] as? String ?? ""
			let imageId: [String] = docData["imageId"] as? [String] ?? []
			let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
			let createdAt: Timestamp = docData["createdAt"] as! Timestamp

			reviews.append(Review(id: id, reviewer: reviewer, foodCartId: foodCartId, grade: grade, description: description, imageId: imageId, upadtedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue()))
		}
		
		return reviews
	}
	
	// Favorite Data Fetch
	func fetchFavorite() async throws -> [FoodCart] {
		guard let userId = UserInfo.token, let currentUser = currentUser else { return [] }
		var favorite = [FoodCart]() // 비동기 통신으로 받아올 Property
		
		for foodCart in currentUser.favoriteId {
			let favoriteSnapshot = try await database.collection("FoodCart").document(foodCart).getDocument() // 첫번째 비동기 통신

			let docData = favoriteSnapshot.data()!
			
			let id: String = docData["id"] as? String ?? ""
			let region: String = docData["region"] as? String ?? ""
			let name: String = docData["name"] as? String ?? ""
			let address: String = docData["address"] as? String ?? ""
			let visitedCnt: Int = docData["visitedCnt"] as? Int ?? 0
			let favoriteCnt: Int = docData["favoriteCnt"] as? Int ?? 0
			let paymentOpt: [String] = docData["paymentOpt"] as? [String] ?? []
			let openingDays: [Bool] = docData["openingDays"] as? [Bool] ?? []
			let menu: [String: Int] = docData["menu"] as? [String: Int] ?? [String: Int]()
			let bestMenu: Int = docData["bestMenu"] as? Int ?? 0
			let imageId: [String] = docData["imageId"] as? [String] ?? []
			let grade: Double = docData["grade"] as? Double ?? 0.0
			let reportCnt: Int = docData["reportCnt"] as? Int ?? 0
			let reviewId: [String] = docData["reviewId"] as? [String] ?? []
			let geoPoint: GeoPoint = docData["geoPoint"] as! GeoPoint
			let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
			let createdAt: Timestamp = docData["createdAt"] as! Timestamp

			favorite.append(FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId))
		}
		
		return favorite
	}
}
