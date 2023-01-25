//
//  ProfileViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
	//MARK: Property wrapper
	@Published var currentUser: User?
	@Published var showLogin = false			// 로그인 관리
	@Published var isFaceID: Bool = UserDefaults.standard.bool(forKey: "isFaceID") {		// FaceID
		willSet { // 값이 변경되기 직전에 호출, newValue에는 새로 초기화하고자 하는 값이 들어감
			UserDefaults.standard.set(newValue, forKey: "isFaceID")
		}
	}
	@Published var isAlert: Bool = UserDefaults.standard.bool(forKey: "isAlert") {			// 알림
		willSet {
			UserDefaults.standard.set(newValue, forKey: "isAlert")
		}
	}
	@Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode") {	// 다크모드
		willSet {
			UserDefaults.standard.set(newValue, forKey: "isDarkMode")
		}
	}

	init() { // 임시: 자동 로그인시 초기화 해줘야함
		UserDefaults.standard.set(false, forKey: "isFaceID")	// FaceID
		UserDefaults.standard.set(false, forKey: "isAlert")		// 알림
		UserDefaults.standard.set(false, forKey: "isDarkMode")	// 다크모드
	}
	
	// 로그아웃
	func logout() async throws {
		currentUser = nil
	}
}
