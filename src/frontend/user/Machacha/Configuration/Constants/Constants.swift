//
//  Constants.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation
import SwiftUI

struct Screen {
	static let maxWidth = UIScreen.main.bounds.width
	static let maxHeight = UIScreen.main.bounds.height
}

struct UserInfo {
	static let token = UserDefaults.standard.string(forKey: "userIdToken")
	static let isFaceID = UserDefaults.standard.bool(forKey: "isFaceID")
	static let isAlert = UserDefaults.standard.bool(forKey: "isAlert")
	static let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
}
