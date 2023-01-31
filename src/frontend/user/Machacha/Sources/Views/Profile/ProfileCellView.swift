//
//  ProfileCellView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileCellView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@State var opacity : Double = 1.0
	@Binding var isFavorite: Bool
	@Binding var foodCart: FoodCart?
//
//	//MARK: Property
//	let foodCart: FoodCart?
//
	var body: some View {
		NavigationLink {
			
		} label: {
			HStack(spacing: 10) {
				RoundedRectangle(cornerRadius: 8) // 임시
					.frame(width: 70, height: 70)
					.foregroundColor(.gray)
				
				VStack(alignment: .leading, spacing: 7) {
					HStack {
						Text(foodCart?.name ?? "가게 이름") // 가게 이름
							.font(.machachaHeadlineBold)
							.foregroundColor(Color("textColor"))
							.lineLimit(2)
							.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
						
						Button {
							
						} label: {
							Image(systemName: "heart.fill")
								.foregroundColor(isFavorite ? Color("Color3") : .gray)
						} // Button
					} // HStack

					Text(foodCart?.address ?? "가게 주소") // 가게 주소
						.foregroundColor(.secondary)
						.fixedSize(horizontal: true, vertical: false)
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(2)
						.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
					
					HStack {
						HStack { // 평점
							Text("★ \(String(format: "%0.1f", foodCart?.grade ?? "평점"))")
								.foregroundColor(Color("Color3"))
								.bold()
								.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
						} // HStack
						HStack(spacing: 13) { // 리뷰
							Text("|")
							Image(systemName: "applepencil")
								.frame(width: 3)
							Text("\(foodCart?.reviewId.count ?? 0)")
								.fixedSize(horizontal: true, vertical: false)
								.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
						} // HStack
						HStack(spacing: 15) { // 즐겨찾기
							Text("|")
							Image(systemName: "heart.fill")
								.frame(width: 3)
							Text("\(foodCart?.favoriteCnt ?? 0)")
								.fixedSize(horizontal: true, vertical: false)
								.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
						} // HStack
						HStack(spacing: 15) { // 가봤어요
							Text("|")
							Image(systemName: "eye.fill")
								.frame(width: 3)
							Text("\(foodCart?.visitedCnt ?? 0)")
								.fixedSize(horizontal: true, vertical: false)
								.setSkeletonView(opacity: opacity, shouldShow: foodCart == nil)
						} // HStack
					} // HStack
					.foregroundColor(Color(uiColor: UIColor.lightGray))
				} // VStack
				.font(.machachaFootnote)
				
				Image(systemName: "chevron.right")
					.foregroundColor(.gray)
			} // HStack
			.padding()
			.overlay {
				RoundedRectangle(cornerRadius: 20)
					.stroke(Color("Color3"), lineWidth: 2)
			}
			.padding()
		} // NavigationLink
	}
}

struct ProfileCellView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()
		
		ProfileCellView(isFavorite: .constant(true), foodCart: .constant(FoodCart.getDummy()))
			.environmentObject(profileVM)
			.onAppear {
				profileVM.currentUser = User.getDummy()
			}
	}
}
