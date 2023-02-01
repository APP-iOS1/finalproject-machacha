//
//  ProfileFoodCartCellView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileFoodCartCellView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@State var opacity: Double = 0.8
	@State var image: UIImage?
	@Binding var isFavorite: Bool
	
	//MARK: Property
	let foodCart: FoodCart
	
	var body: some View {
		NavigationLink {
			
		} label: {
			HStack(spacing: 10) {
				VStack {
					if let image = image {
						Image(uiImage: image)
							.resizable()
							.frame(width: 70, height: 70)
							.clipShape(RoundedRectangle(cornerRadius: 8))
							.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
					} else {
						RoundedRectangle(cornerRadius: 8) // 임시
							.foregroundColor(.gray)
					}
				}
				.frame(width: 70, height: 70)
				.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
				
				VStack(alignment: .leading, spacing: 7) {
					HStack {
						Text(foodCart.name) // 가게 이름
							.font(.machachaHeadlineBold)
							.foregroundColor(Color("textColor"))
							.lineLimit(2)
						
						Button {
							
						} label: {
							Image(systemName: "heart.fill")
								.foregroundColor(isFavorite ? Color("Color3") : .gray)
						} // Button
					} // HStack
					.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
					
					Text(foodCart.address) // 가게 주소
						.foregroundColor(.secondary)
						.fixedSize(horizontal: true, vertical: false)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(2)
						.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
					
					HStack {
						HStack { // 평점
							Text("★ \(foodCart.gradeRounded)")
								.foregroundColor(Color("Color3"))
								.bold()
						} // HStack
						.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
						
						HStack(spacing: 15) { // 즐겨찾기
							Text("|")
							Image(systemName: "heart.fill")
								.frame(width: 3)
							Text("\(foodCart.favoriteCnt)")
								.fixedSize(horizontal: true, vertical: false)
						} // HStack
						.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
						
						HStack(spacing: 15) { // 가봤어요
							Text("|")
							Image(systemName: "checkmark.seal.fill")
								.frame(width: 3)
							Text("\(foodCart.visitedCnt)")
								.fixedSize(horizontal: true, vertical: false)
						} // HStack
						.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
						
						HStack(spacing: 13) { // 리뷰
							Text("|")
							Image(systemName: "square.and.pencil")
								.frame(width: 3)
							Text("\(foodCart.reviewId.count)")
								.fixedSize(horizontal: true, vertical: false)
						} // HStack
						.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
					} // HStack
					.foregroundColor(Color(uiColor: UIColor.lightGray))
				} // VStack
				.font(.machachaFootnote)
				
				Image(systemName: "chevron.right")
					.foregroundColor(.gray)
					.unredacted()
			} // HStack
			.padding()
			.overlay {
				RoundedRectangle(cornerRadius: 20)
					.stroke(Color("Color3"), lineWidth: 2)
			}
			.padding(.horizontal)
			.onAppear {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
					self.opacity = opacity == 0.4 ? 0.8 : 0.4
				}
				Task {
					image = try await profileVM.fetchImage(foodCartId: foodCart.id, imageName: foodCart.imageId.first ?? "test")
				}
			}
		} // NavigationLink
	}
}

struct ProfileFoodCartCellView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()
		
		ProfileFoodCartCellView(isFavorite: .constant(true), foodCart: FoodCart.getDummy())
			.environmentObject(profileVM)
			.onAppear {
				profileVM.currentUser = User.getDummy()
			}
	}
}
