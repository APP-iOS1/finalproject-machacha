//
//  AnimationModifier.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

//MARK: 반짝이는 스켈레톤 View
struct BlinkingAnimatinoModifier: AnimatableModifier {
	//MARK: Property
	var shouldShow: Bool
	var opacity: Double
	var animatableData: Double {
		get { opacity }
		set { opacity = newValue }
	}
	
	// zIndex: ZStack 우선순위 정하기(stack처럼 쌓이고, 이래야 ZStack끼리 오류가 적게 발생)
	func body(content: Content) -> some View {
		content.overlay(
			ZStack {
				Color.white.zIndex(0)					// 뒤의 Conent가 보이지 않도록
				RoundedRectangle(cornerRadius: 8)
					.fill(.gray.opacity(0.5))
					.opacity(self.opacity).zIndex(1)	// 우선순위 1
			}.opacity(shouldShow ? 1 : 0)
		)
	}
}

extension View {
	func setSkeletonView(opacity: Double, shouldShow: Bool) -> some View {
		self.modifier(BlinkingAnimatinoModifier(shouldShow: shouldShow, opacity: opacity))
	}
}
