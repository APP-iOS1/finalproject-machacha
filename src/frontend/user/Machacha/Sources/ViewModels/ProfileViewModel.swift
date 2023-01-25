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
	
	// 로그아웃
	func logout() async throws {
		currentUser = nil
	}
}
