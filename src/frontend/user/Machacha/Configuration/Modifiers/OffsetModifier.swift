//
//  OffsetModifier.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/04.
//

import SwiftUI

//Setting Scrollview offset
struct OffsetModifier: ViewModifier {
	@Binding var offset : CGFloat
	func body (content : Content ) -> some View {
		content.overlay(
			GeometryReader{
				proxy -> Color in
				
				// 스크롤이라는 좌표 공간에 대한 값 얻기
				let minY = proxy.frame(in: .named("SCROLL")).minY
				
				DispatchQueue.main.async {
					self.offset = minY
				}
				
				return Color.clear
			}
		)
	}
}
