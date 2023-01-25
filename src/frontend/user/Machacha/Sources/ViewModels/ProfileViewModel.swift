//
//  ProfileViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
	@Published var currentUser: User?
	@Published var showLogin = false			// 로그인 관리
	@Published var isFaceID = false				// FaceID
	@Published var isAlert = false				// 알림
	@Published var isDarkMode = false			// 다크모드

	// 로그아웃
	func logout() async throws {
		currentUser = nil
	}
}
