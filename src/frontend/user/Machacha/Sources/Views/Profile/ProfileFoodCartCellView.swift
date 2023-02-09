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
	@State private var showDetail = false
	
	//MARK: Property
	let foodCartOfUserType: FoodCartOfUserType
	let foodCart: FoodCart
	let isFavorite: Bool
	
	var body: some View {
		Button {
			showDetail.toggle()
		} label: {
			VStack {
				if foodCartOfUserType == .visited || foodCartOfUserType == .register { // 가봤어요 일경우
					HStack {
						Image(systemName: foodCartOfUserType.image)
							.foregroundColor(foodCartOfUserType.color)
							.overlay {
								Image(systemName: foodCartOfUserType.badge)
									.resizable()
									.scaledToFit()
									.frame(width: 10)
									.offset(x: -9, y: 8)
									.foregroundColor(foodCartOfUserType.color)
									.opacity(profileVM.isLoading ? 0 : 1)
							}
						
						Text(foodCartOfUserType == .visited ? "\(foodCart.updatedAt.getDay(format: "yy.MM.dd")) 에 방문" : "\(foodCart.createdAt.getDay(format: "yy.MM.dd")) 에 등록")
							.font(.machachaFootnote)
							.foregroundColor(.secondary)
						Spacer()
					}
					.setSkeletonView(opacity: opacity, shouldShow: profileVM.isLoading)
				}
				HStack(spacing: 10) {
					VStack {
						if let image = image {
							Image(uiImage: image)
								.resizable()
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
						HStack(alignment: .top) {
							Text(foodCart.name) // 가게 이름
								.font(.machachaHeadlineBold)
								.foregroundColor(Color("textColor"))
								.multilineTextAlignment(.leading)
								.lineLimit(2)
							
							Image(systemName: "heart.fill")
								.foregroundColor(isFavorite ? Color("Color3") : .gray)
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
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8)
				.stroke(Color("textColor"), lineWidth: 0.1))
			.padding(.horizontal)
			.onAppear {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
					self.opacity = opacity == 0.4 ? 0.8 : 0.4
				}
				Task {
					image = try await profileVM.fetchImage(foodCartId: foodCart.id, imageName: foodCart.imageId.first ?? "test")
				}
			}
			.navigationDestination(isPresented: $showDetail) {
				DetailView(selectedStore: foodCart)
			}
		} // Button
	}
}

struct ProfileFoodCartReviewCellView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@State var opacity: Double = 0.8
	@State var imageList: [UIImage]?
	@State private var showDetail = false

	//MARK: Property
	let user: User
	let foodCartOfUserType: FoodCartOfUserType
	let foodCart: FoodCart
	let review: Review
	let isFavorite: Bool
	
	var body: some View {
		Button {
			showDetail.toggle()
		} label: {
			VStack {
				HStack(alignment: .top) {
					VStack { // 프로필 사진
						if let image = profileVM.profileImage {
							Image(uiImage: image)
								.resizable()
								.scaledToFit()
						} else {
							RoundedRectangle(cornerRadius: 40) // 임시
								.foregroundColor(Color("bgColor"))
						}
					} // VStack
					.frame(width: 40, height: 40)
					.cornerRadius(40)

					VStack(alignment: .leading) {
						Text(user.name)
							.font(.machachaHeadlineBold)
						// 별점
						HStack(alignment: .center) {
							Image(systemName: "star.fill")
								.foregroundColor(Color("Color3"))
							Text("\(review.gradeRounded)")
							Text("| \(review.updatedAt.getDay())")
								.foregroundColor(.gray)
								.font(.machachaHeadline)
						} // HStack
					} // VStack
					Spacer()
					Menu {
						MenuView(review: review)
					} label: {
						Image(systemName: "ellipsis")
							.foregroundColor(.gray)
					} // Menu
				} // HStack
				.font(.machachaHeadline)

			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8)
				.stroke(Color("textColor"), lineWidth: 0.1))
			.padding(.horizontal)
			.onAppear {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
					self.opacity = opacity == 0.4 ? 0.8 : 0.4
				}
				Task {
					for imageId in review.imageId {
						let image = try await profileVM.fetchImage(foodCartId: review.id, imageName: imageId)
						imageList?.append(image)
					}
				}
			}
			.navigationDestination(isPresented: $showDetail) {
				DetailView(selectedStore: foodCart)
			}
		} // Button
	}
}

struct ProfileFoodCartCellView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()
		
		ZStack {
			Color("bgColor")
			ProfileFoodCartCellView(foodCartOfUserType: .register, foodCart: FoodCart.getDummy(), isFavorite: true)
				.environmentObject(profileVM)
				.onAppear {
					profileVM.currentUser = User.getDummy()
				}
		}
	}
}
