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
			List {
				Section(header: Text("3회 이상 누적된 포장마차만 노출")) {
					ForEach(Array(reportVM.reportFoodCarts.enumerated()), id: \.offset) { index, foodCart in
						FoodCartReportCellView(reportVM: reportVM, index: index, foodCart: foodCart)
							.listRowBackground(Color.white.overlay(Rectangle().stroke(Color.black, lineWidth: 0.5)))
					} // ForEach
				}
			} // List
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
					reportVM.reportFoodCarts = await reportVM.fetchFoodCarts()
				} // Task
			}
		}
	}
}

// MARK: - FoodCart Cell View
struct FoodCartReportCellView: View {
	//MARK: Property Wrapper
	@ObservedObject var reportVM: ReportViewModel
	@State private var image: UIImage?
	
	//MARK: Property
	let index: Int
	var foodCart: FoodCart
	
	var body: some View {
		NavigationLink {
			
		} label: {
			VStack(alignment: .leading) {
				HStack(spacing: 16) {
					VStack {
						Image(systemName: "square")
							.resizable()
							.frame(width: 22, height: 22)
							.overlay {
								Text("\(index + 1)")
									.font(.caption)
							}
					}
					
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
		}
		.onAppear {
			Task {
				if let first = foodCart.imageId.first {
					image = await reportVM.fetchImage(foodCartId: foodCart.id, imageName: first)
				}
			}
		}
	}
}

struct ReportView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ReportView()
				.navigationTitle("신고 누적 가게")
		}
	}
}
