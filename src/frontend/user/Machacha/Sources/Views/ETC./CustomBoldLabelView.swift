//
//  CustomBoldLabelView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import Foundation
import UIKit
import SwiftUI

struct CustomBoldLabelView: View {
	//MARK: Property Wrapper
	@State private var height: CGFloat = .zero
	
	//MARK: Property
	var text1: String
	var text2: String
	var user: String
	var task: String
	
	var body: some View {
		InternalLabelView(dynamicHeight: $height, text1: text1, text2: text2, user: user, task: task)
			.frame(minHeight: height)
	}
	
	struct InternalLabelView: UIViewRepresentable {
		//MARK: Property Wrapper
		@Binding var dynamicHeight: CGFloat

		//MARK: Property
		var text1: String
		var text2: String
		var user: String
		var task: String
		
		func makeUIView(context: Context) -> UILabel {
			
			let style = NSMutableParagraphStyle()
			style.lineSpacing = 8
			
			let boldTextAttributes: [NSAttributedString.Key : Any] = [ // 강조 attribute
				NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundOTFB", size: 14) ??  UIFont.systemFont(ofSize: 14),
				NSAttributedString.Key.foregroundColor: UIColor.label,
				NSAttributedString.Key.paragraphStyle: style
			]
			
			let defaultTextAttributes: [NSAttributedString.Key : Any] = [ // 기본 attribute
				NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundOTFR", size: 14) ??  UIFont.systemFont(ofSize: 14),
				NSAttributedString.Key.foregroundColor: UIColor.label,
				NSAttributedString.Key.paragraphStyle: style
			]
			
			let attributedText1 = NSMutableAttributedString(string: user)
			attributedText1.addAttributes(boldTextAttributes, range: attributedText1.range) // check extention
			
			let boldText1 = NSMutableAttributedString(string: text1)
			boldText1.addAttributes(defaultTextAttributes, range: boldText1.range)
			attributedText1.append(boldText1)
			
			let attributedText2 = NSMutableAttributedString(string: task)
			attributedText2.addAttributes(boldTextAttributes, range: attributedText2.range) // check extention
			attributedText1.append(attributedText2)
			
			let boldText2 = NSMutableAttributedString(string: text2)
			boldText2.addAttributes(defaultTextAttributes, range: boldText2.range)
			attributedText1.append(boldText2)
			
			let label = UILabel()
			label.numberOfLines = 0
			label.lineBreakMode = .byCharWrapping
			label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			label.attributedText = attributedText1
			
			return label
		}
		
		func updateUIView(_ uiView: UILabel, context: Context) {
			DispatchQueue.main.async {
				dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
			}
		}
	}
}


extension NSMutableAttributedString {
	var range: NSRange {
		NSRange(location: 0, length: self.length)
	}
}
