////
////  OCRViewModel.swift
////  Machacha
////
////  Created by geonhyeong on 2023/02/14.
////
//
//import Foundation
//import MLKitTextRecognitionKorean
//import MLKitVision
//import AVFoundation
//
//final class OCRViewModel: ObservableObject {
//	@Published var uiImage: UIImage?
//	@Published var isLoding: Bool = false
//	@Published var menu: Set<String> = []
//	@Published var price: Set<String> = []
//
//	func reconizeTextKorean() {
//		let koreanOptions = KoreanTextRecognizerOptions()
//		let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
//
//		guard let uiImage = uiImage else { return }
//		let visionImage = VisionImage(image: uiImage)
//		visionImage.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back)
//
//		isLoding = true
//		
//		// 이미지 처리
//		koreanTextRecognizer.process(visionImage) { features, error in
//			koreanTextRecognizer.process(visionImage) { result, error in
//				guard error == nil, let result = result else {
//					// Error handling
//					print("Error")
//					return
//				}
//				
//				// 가격 후처리
//				self.getPostProcessing(resultText: result)
//				
//				self.isLoding = false
//			}
//		}
//	}
//
//	// 메뉴 & 가격 후처리
//	func getPostProcessing(resultText: Text) {
//		let menuType = ["오뎅", "치즈", "소세지", "떡", "맛 살", "고추", "깻잎"]
//		
//		for block in resultText.blocks {
//			if block.text.contains("원") || block.text.contains(",") {
//				let number = block.text.filter{$0.isNumber} // 숫자만 추출
//				price.insert(number)
//			} else if menuType.contains(block.text) {
//				menu.insert(block.text)
//			}
//		}
//	}
//	
//	// VisionImage의 방향
//	func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
//		switch deviceOrientation {
//		case .portrait:
//			return cameraPosition == .front ? .leftMirrored : .right
//		case .landscapeLeft:
//			return cameraPosition == .front ? .downMirrored : .up
//		case .portraitUpsideDown:
//			return cameraPosition == .front ? .rightMirrored : .left
//		case .landscapeRight:
//			return cameraPosition == .front ? .upMirrored : .down
//		case .faceDown, .faceUp, .unknown:
//			return .up
//		@unknown default:
//			fatalError()
//		}
//	}
//
//}
//
