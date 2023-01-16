//
//  BtnModifier.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation
import SwiftUI

// MARK: - 제품 상세 페이지의 버튼들에 대한 Modifier

struct ProductButtonModifier: ViewModifier {
	var color: Color
	
	func body(content: Content) -> some View {
		content
			.padding()
			.background(color)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.padding(.horizontal)
	}
}

// MARK: - 회색 테두리 버튼에 사용될 모디파이어.

struct GreyBorderedButtonModifier: ViewModifier {
	var textColor = Color.black
	var borderColor = Color.gray.opacity(0.8)
	var backgroundColor = Color.white
	var lineWidth: CGFloat = 0.5

	func body(content: Content) -> some View {
		content
			.foregroundColor(textColor)
			.padding(.vertical, 10)
			.frame(maxWidth: .infinity)
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(borderColor, lineWidth: lineWidth)
			)
			.background(backgroundColor)
	}
}

// MARK: - 대표색 테두리 버튼에 사용될 모디파이어.

struct AccentColorBorderedButtonModifier: ViewModifier {
	var textColor = Color("AccentColor")
	var borderColor = Color("AccentColor")
	var backgroundColor = Color.white
	var lineWidth: CGFloat = 1.5

	func body(content: Content) -> some View {
		content
			.foregroundColor(textColor)
			.padding(.vertical, 10)
			.frame(maxWidth: .infinity)
			.overlay(
				RoundedRectangle(cornerRadius: 5)
					.stroke(borderColor, lineWidth: lineWidth)
			)
			.background(backgroundColor)
	}
}

// MARK: - 배경색이 들어간 버튼에 사용될 모디파이어.
///버튼 크기에 따라 cornerRadius를 5, 10 으로 구분지어 사용하면 된다

struct ColoredButtonModifier: ViewModifier {
	var color: Color = Color("AccentColor")
	var cornerRadius: CGFloat

	func body(content: Content) -> some View {
		content
			.foregroundColor(.white)
			.padding()
			.bold()
			.background(color)
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
			.padding(.horizontal)
	}
}

// MARK: - 배경색이 들어간 버튼에 사용될 모디파이어. maxWidth가 .infinity
///버튼 크기에 따라 cornerRadius를 5, 10 으로 구분지어 사용하면 된다

struct MaxWidthColoredButtonModifier: ViewModifier {
	var color: Color = Color("AccentColor")
	var cornerRadius: CGFloat

	func body(content: Content) -> some View {
		content
			.font(.subheadline)
			.foregroundColor(.white)
			.padding()
			.frame(maxWidth: .infinity)
			.bold()
			.background(color)
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
			.padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
	}
}
