//
//  Ex+View.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/26.
//

import Foundation
import SwiftUI

extension View {
	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content) -> some View {

		ZStack(alignment: alignment) {
			placeholder().opacity(shouldShow ? 1 : 0)
			self
		}
	}
}
