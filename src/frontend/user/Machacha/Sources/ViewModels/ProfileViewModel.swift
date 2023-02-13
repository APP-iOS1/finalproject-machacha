//
//  ProfileViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class ProfileViewModel: ObservableObject {
	//MARK: Property wrapper
	@Published var currentUser: User?
	@Published var foodCartUser: [FoodCart] = []
	@Published var reviewUser: [Review] = []
	@Published var notification: [UserNotification] = []
	@Published var profileImage: UIImage?
	@Published var name = "" {
		willSet {
			currentUser?.name = newValue
		}
	}
	@Published var isLoading = false
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
	private let storage = Storage.storage()
	
	init() { // 임시: 자동 로그인시 초기화 해줘야함
		UserDefaults.standard.set(false, forKey: "isFaceID")	// FaceID
		UserDefaults.standard.set(false, forKey: "isAlert")		// 알림
		UserDefaults.standard.set(false, forKey: "isDarkMode")	// 다크모드
	}
	
	// 로그아웃
	func logout() async throws {
//		currentUser = nil
	}
	
	//MARK: - Read
	// User Data Fetch
	func fetchUser() async throws -> User? {
		guard let userId = UserInfo.token else { return nil }
		var user: User // 비동기 통신으로 받아올 Property
		
		let userSnapshot = try await database.collection("User").document(userId).getDocument() // 첫번째 비동기 통신
        
        guard let docData = userSnapshot.data() else {
            print("fetchUser 데이터없음")
            return nil
        }
		
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

            reviews.append(Review(id: id, reviewer: reviewer, foodCartId: foodCartId, grade: grade, description: description, imageId: imageId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue()))
		}
		
		return reviews.sorted {$0.updatedAt > $1.updatedAt}
	}
	
	// Notification Data Fetch
	func fetchNotification() async throws -> [UserNotification] {
		guard let userId = UserInfo.token else { return [] }
		var notification = [UserNotification]() // 비동기 통신으로 받아올 Property
		
		let notiSnapshot = try await database.collection("Notification").whereField("userId", arrayContains: userId).getDocuments() // 첫번째 비동기 통신
		
		for noti in notiSnapshot.documents {
			let docData = noti.data()
			
			let id: String = docData["id"] as? String ?? ""
			let userId: [String] = docData["userId"] as? [String] ?? []
			let navigationType: String = docData["navigationType"] as? String ?? ""
			let contentType: String = docData["contentType"] as? String ?? ""
			let contents: String = docData["contents"] as? String ?? ""
			let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
			let createdAt: Timestamp = docData["createdAt"] as! Timestamp

			notification.append(UserNotification(id: id, userId: userId, navigationType: navigationType, contentType: contentType, contents: contents, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue()))
		}
		
		return notification.sorted {$0.createdAt > $1.createdAt}
	}
	
	// Resgiste(등록한 가게) Data Fetch
	func fetchFoodCartByRegister() async throws -> [FoodCart] {
		guard let userId = UserInfo.token else { return [] }
		var favorite = [FoodCart]() // 비동기 통신으로 받아올 Property
		
		let registerSnapshot = try await database.collection("FoodCart").whereField("registerId", isEqualTo: userId).getDocuments() // 첫번째 비동기 통신
		
		for foodCart in registerSnapshot.documents {
			let docData = foodCart.data()
			
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

			favorite.append(FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId))
		}
		
		return favorite.sorted {$0.createdAt > $1.createdAt}
	}
		
	// 즐겨찾기, 내가쓴리뷰, 가봤어요, 내가 등록한 가게에 따라 fetchData를 다르게 반환
	func fetchFoodCartByType(foodCartType: FoodCartOfUserType) async throws -> [FoodCart] {
		guard let currentUser = currentUser else { return [] }
		var favorite = [FoodCart]() // 비동기 통신으로 받아올 Property
		
		var foodCartIdList: [String]
		
		switch foodCartType {
		case .favorite:	// 즐겨찾기
			foodCartIdList = currentUser.favoriteId
		case .review:	// 내가쓴리뷰
			foodCartIdList = reviewUser.map{$0.foodCartId}
		case .visited:	// 가봤어요
			foodCartIdList = currentUser.visitedId
		case .register:	// 내가 등록한 가게
			return try await fetchFoodCartByRegister()
		}
		
		for foodCart in foodCartIdList {
			let favoriteSnapshot = try await database.collection("FoodCart").document(foodCart).getDocument() // 첫번째 비동기 통신

			let docData = favoriteSnapshot.data()!
			
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

			favorite.append(FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId))
		}
		
		return favorite.sorted {$0.updatedAt > $1.updatedAt}
	}
	
	// MARK: - 서버의 Storage에서 이미지를 가져오는 Method
	func fetchImage(foodCartId: String, imageName: String) async throws -> UIImage {
		let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
		
		let data = try await ref.data(maxSize: 1 * 1024 * 1024)
		
		return UIImage(data: data)!
	}
	
	// MARK: - 서버의 Storage에 이미지를 업로드하는 Method
	func uploadImage(image: UIImage, name: String) {
		let storageRef = storage.reference().child("images/\(name)") // 수현님께 경로 관련 질문
		let data = image.jpegData(compressionQuality: 0.1)
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpg"
		
		// uploda data
		if let data = data {
			storageRef.putData(data, metadata: metadata) { (metadata, err) in
				if let err = err {
					print("err when uploading jpg\n\(err)")
				}
				
				if let metadata = metadata {
					print("metadata: \(metadata)")
				}
			}
		}
	}
	
	//MARK: - Update
	// User Data
	func updateUser(uiImage: UIImage, name: String) async -> Bool {
        
		guard let currentUser = currentUser else {
            print("실패 : currentUser 없음")
            return false
        }
		do {
			let imgName = UUID().uuidString //imgName: 이미지마다 id를 만들어줌
			
			uploadImage(image: uiImage, name: (currentUser.id + "/" + imgName))
			
			try await database.collection("User")
				.document(currentUser.id)
				.setData(["id": currentUser.id,
						  "isFirstLogin": false,
						  "email": currentUser.email,
						  "name": name,
						  "profileId": imgName,
						  "favoriteId": currentUser.favoriteId,
						  "visitedId": currentUser.visitedId,
						  "updatedAt": Date(),
						  "createdAt": currentUser.createdAt
						 ])
		} catch {
			return false
		}
		
		return true // 성공
	}
    
}

