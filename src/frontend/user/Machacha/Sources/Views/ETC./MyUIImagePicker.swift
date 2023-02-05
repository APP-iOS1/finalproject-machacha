//
//  MyUIImagePicker.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/04.
//

import SwiftUI

struct MyUIImagePicker: UIViewControllerRepresentable {
	@Binding var imagePickerVisible: Bool
	@Binding var selectedImage: UIImage?
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<MyUIImagePicker>) -> UIImagePickerController {
		
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context:  UIViewControllerRepresentableContext<MyUIImagePicker>) {
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(imagePickerVisible: $imagePickerVisible, selectedImage: $selectedImage)
	}
	
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		@Binding var imagePickerVisible: Bool
		@Binding var selectedImage: UIImage?
		
		init(imagePickerVisible: Binding<Bool>, selectedImage: Binding<UIImage?>) {
			_imagePickerVisible = imagePickerVisible
			_selectedImage = selectedImage
		}
		
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			imagePickerVisible = false
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			
			let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
			selectedImage = image
			imagePickerVisible = false
		}
	}
}
