//
//  Ex+UIDevice.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/11.
//

import UIKit

extension UIDevice { // SE VS 그 외 디바이스 구분
	static var hasNotch: Bool {
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		let window = windowScene?.windows.filter {$0.isKeyWindow}.first
		let bottom = window?.safeAreaInsets.bottom ?? 0
		return bottom > 0
	}
}
