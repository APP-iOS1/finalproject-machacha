//
//  ReportView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ReportView: View {
	//MARK: Property Wrapper
	@StateObject var reportVM = ReportViewModel()
	
	var body: some View {
		NavigationView {
			ScrollView {
				ForEach(Array(reportVM.reportFoodCart.enumerated()), id: \.offset) { index, reportFoodCart in
					FoodCartReportCellView(reportVM: reportVM, index: index, reportFoodCart: reportFoodCart)
						.listRowBackground(Color.white.overlay(Rectangle().stroke(Color.black, lineWidth: 0.5)))
				} // ForEach
			} // List
			.refreshable {
				Task {
					reportVM.report = await reportVM.fetchReports()
					reportVM.reportFoodCart = reportVM.report.filter {$0.type == 0}
				} // Task
			}
			.padding(.top, 16)
			.background(Color("bgColor"))
			.scrollContentBackground(.hidden)
			.navigationBarBackButtonHidden()
			.navigationBarTitle(Tab.report.title, displayMode: .inline)
			.toolbarBackground(Color.accentColor, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						
					} label: {
						Text("제거")
					}
				} // ToolbarItem
			})
			.onAppear {
				Task {
					reportVM.report = await reportVM.fetchReports()
					reportVM.reportFoodCart = reportVM.report.filter {$0.type == 0}
				} // Task
			}
		}
	}
}

// MARK: - FoodCart Cell View
struct FoodCartReportCellView: View {
	//MARK: Property Wrapper
	@StateObject var reportVM: ReportViewModel
	@State private var image: UIImage?
	@State private var showDetail = false
	@State private var foodCart: FoodCart = FoodCart.getDummy()
	@State private var userName: String = ""
	@State private var userProfile: UIImage?
	@State private var isLoading: Bool = false

	//MARK: Property
	let index: Int
	let reportFoodCart: Report

	var body: some View {
		Button {
			showDetail.toggle()
		} label: {
			VStack(alignment: .leading, spacing: 16) {
				HStack(spacing: 16) {
//					VStack {
//						Image(systemName: "square")
//							.resizable()
//							.frame(width: 22, height: 22)
//							.overlay {
//								Text("\(index + 1)")
//									.font(.caption)
//							}
//							.foregroundColor(.black)
//					}
//					Divider()
					HStack(spacing: 8) {
						VStack { // 프로필 사진
							if let image = userProfile {
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
						Text("신고자 : \(userName)")
							.font(.system(size: 17))
							.foregroundColor(Color("textColor"))
					}
					
					
				} // VStack
				Divider()
				HStack(spacing: 16) {
					VStack {
						if let image = image {
							Image(uiImage: image)
								.resizable()
								.clipShape(RoundedRectangle(cornerRadius: 8))
						} else {
							RoundedRectangle(cornerRadius: 8) // 임시
								.foregroundColor(.gray)
						}
					} // VStack
					.frame(width: 70, height: 70)
					
					VStack(alignment: .leading, spacing: 8) {
						Text(foodCart.name)
							.multilineTextAlignment(.leading)
							.lineLimit(2)
							.foregroundColor(Color(uiColor: .label))
						
						Text(foodCart.address) // 가게 주소
							.font(.caption)
							.foregroundColor(.secondary)
							.fixedSize(horizontal: true, vertical: false)
							.frame(maxWidth: .infinity, alignment: .leading)
							.lineLimit(2)
						
						HStack {
							HStack { // 평점
								Text("★ \(foodCart.gradeRounded)")
									.foregroundColor(.orange)
									.fixedSize(horizontal: true, vertical: false)
									.bold()
							} // HStack
							
							HStack(spacing: 15) { // 즐겨찾기
								Text("|")
								Image(systemName: "heart.fill")
									.frame(width: 3)
								Text("\(foodCart.favoriteCnt)")
									.fixedSize(horizontal: true, vertical: false)
							} // HStack
							
							HStack(spacing: 15) { // 가봤어요
								Text("|")
								Image(systemName: "checkmark.seal.fill")
									.frame(width: 3)
								Text("\(foodCart.visitedCnt)")
									.fixedSize(horizontal: true, vertical: false)
							} // HStack
							
							HStack(spacing: 13) { // 리뷰
								Text("|")
								Image(systemName: "square.and.pencil")
									.frame(width: 3)
								Text("\(foodCart.reviewId.count)")
									.fixedSize(horizontal: true, vertical: false)
							} // HStack
						} // HStack
						.font(.caption)
						.foregroundColor(Color(uiColor: UIColor.lightGray))
					} // VStack
				} // HStack
			} // VStack
			.padding()
		}
		.background(Color("cellColor"))
		.cornerRadius(8)
		.overlay(RoundedRectangle(cornerRadius: 8)
			.stroke(Color("textColor"), lineWidth: 0.1))
		.padding(.horizontal)
		.onAppear {
			isLoading = true
			Task {
				foodCart = await reportVM.fetchFoodCart(foodCartId: reportFoodCart.targetId)

				let (name, profileId) = await reportVM.fetchReviews(userId: reportFoodCart.userId)
				self.userName = name
				self.userProfile = await reportVM.fetchImage(foodCartId: reportFoodCart.userId, imageName: profileId)
				
				if let first = foodCart.imageId.first {
					image = await reportVM.fetchImage(foodCartId: foodCart.id, imageName: first)
				}
				isLoading = false
			}
		}
		.navigationDestination(isPresented: $showDetail) {
			ReportDetailView(reportVM: reportVM, report: reportFoodCart)
		}
	}
}

struct ReportView_Previews: PreviewProvider {
	static var previews: some View {
		ReportView()
	}
}
