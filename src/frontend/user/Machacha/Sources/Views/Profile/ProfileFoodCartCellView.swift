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
			.redacted(reason: profileVM.isLoading ? .placeholder : [])	// 콘텐츠 모자이크
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
		.disabled(profileVM.isLoading)
	}
}

struct ProfileFoodCartReviewCellView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@EnvironmentObject var foodCartVM: FoodCartViewModel
	@State private var opacity: Double = 0.8
	@State private var imageList: [UIImage] = []
	@State private var showDetail = false
	@State private var foodCart: FoodCart = FoodCart.getDummy()
	@Binding var isLoading: Bool
	
	//MARK: Property
	let review: Review
	
	var body: some View {
		ZStack(alignment: .topTrailing) {
			Button {
				showDetail.toggle()
			} label: {
				VStack(alignment: .leading, spacing: 8) {
					HStack(spacing: 8) {
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
						.setSkeletonView(opacity: opacity, shouldShow: isLoading)
						
						VStack(alignment: .leading, spacing: 4) {
							Text(profileVM.currentUser!.name)
								.font(.machachaHeadlineBold)
								.foregroundColor(Color("textColor"))
								.setSkeletonView(opacity: opacity, shouldShow: isLoading)
							
							// 별점
							HStack {
								HStack(spacing: 4) {
									Image(systemName: "star.fill")
										.foregroundColor(Color("Color3"))
									
									Text("\(review.gradeRounded)")
										.foregroundColor(Color("textColor"))
										.fixedSize(horizontal: true, vertical: false)
								}
								.font(.machachaHeadlineBold)
								.setSkeletonView(opacity: opacity, shouldShow: isLoading)
								
								Text("|")
									.foregroundColor(.gray)
									.unredacted()
								
								Text("\(review.updatedAt.getDay())")
									.foregroundColor(.gray)
									.font(.machachaFootnote)
									.setSkeletonView(opacity: opacity, shouldShow: isLoading)
							} // HStack
						} // VStack
						
						Spacer()
					} // HStack
					.font(.machachaHeadline)
					
					LazyVStack {
						if isLoading {
							Rectangle()
								.foregroundColor(.gray)
								.frame(width: Screen.maxWidth - 32, height: 200)
						} else {
							if !imageList.isEmpty {
								if imageList.count == 1, let image = imageList.first! { // 사진이 1개 일떄
									Image(uiImage: image)
										.resizable()
										.scaledToFit()
										.frame(width: Screen.maxWidth - 32)
								} else { // 사진이 여러개 일때
									ScrollView (.horizontal, showsIndicators: false) {
										LazyHStack {
											ForEach(imageList, id: \.self) { image in
												Image(uiImage: image)
													.resizable()
													.scaledToFit()
													.cornerRadius(8)
													.frame(height: 200)
											} // ForEach
										} // LazyHStack
									} // ScrollView
								}
							}
						}
					}
					.cornerRadius(8)
					.setSkeletonView(opacity: opacity, shouldShow: isLoading)
					
					Text(review.description) // 댓글
						.font(.machachaSubhead)
						.lineSpacing(8)
						.foregroundColor(Color("textColor"))
						.setSkeletonView(opacity: opacity, shouldShow: isLoading)
				} // VStack
				.redacted(reason: isLoading ? .placeholder : [])	// 콘텐츠 모자이크
				.padding()
				.background(Color("cellColor"))
				.cornerRadius(8)
				.overlay(RoundedRectangle(cornerRadius: 8)
					.stroke(Color("textColor"), lineWidth: 0.1))
				.onAppear {
					withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
						self.opacity = opacity == 0.4 ? 0.8 : 0.4
					}
					isLoading = true
					Task {
						do {
							for imageId in review.imageId {
								let image = try await profileVM.fetchImage(foodCartId: review.id, imageName: imageId)
								imageList.append(image)
							}
							
							// review Id로 foodCart받아오기
							foodCart = await foodCartVM.fetchFoodCartByFoodCartId(review.foodCartId)
							isLoading = false
						} catch {
							isLoading = false
						}
					}
				}
				.navigationDestination(isPresented: $showDetail) {
					DetailView(selectedStore: foodCart)
				}
			} // Button
			.disabled(isLoading)

			Menu {
				MenuView(review: review)
			} label: {
				Image(systemName: "ellipsis")
					.foregroundColor(.gray)
					.padding(20)
					.padding(.top, 4) // profileVM.currentUser!.name과 같은 spacing
			} // Menu
			.unredacted()
			.disabled(isLoading)
		} // ZStack
		.padding(.horizontal)
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
