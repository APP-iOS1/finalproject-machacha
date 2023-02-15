//
//  ReportReviewView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ReportReviewView: View {
	//MARK: Property Wrapper
	@StateObject var reportVM = ReportViewModel()

    var body: some View {
		NavigationView {
			ScrollView {
				ForEach(Array(reportVM.reportReview.enumerated()), id: \.offset) { index, reportReview in
					ReportReviewCellView(reportVM: reportVM, index: index, reportReview: reportReview)
						.listRowBackground(Color.white.overlay(Rectangle().stroke(Color.black, lineWidth: 0.5)))
				} // ForEach

			} // List
			.refreshable {
				Task {
					reportVM.report = await reportVM.fetchReports()
					reportVM.reportReview = reportVM.report.filter {$0.type == 1}
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
					reportVM.reportReview = reportVM.report.filter {$0.type == 1}
				}
			}
		} // NavigationView
    }
}

struct ReportReviewCellView: View {
	//MARK: Property wrapper
	@StateObject var reportVM: ReportViewModel
	@State private var imageList: [UIImage] = []
	@State private var showDetail = false
	@State private var review: Review = Review.getDummy1()
	@State private var userName: String = ""
	@State private var userProfile: UIImage?
	@State private var isLoading: Bool = false

	//MARK: Property
	let index: Int
	let reportReview: Report
	
	var body: some View {
		ZStack(alignment: .topTrailing) {
			Button {
				showDetail.toggle()
			} label: {
				VStack(alignment: .leading, spacing: 8) {
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
						
						VStack(alignment: .leading, spacing: 4) {
							Text("신고자 : \(userName)")
								.font(.system(size: 17))
								.foregroundColor(Color("textColor"))
							
							// 별점
							HStack {
								HStack(spacing: 4) {
									Image(systemName: "star.fill")
										.foregroundColor(Color.accentColor)
									
									Text("\(review.gradeRounded)")
										.foregroundColor(Color("textColor"))
										.fixedSize(horizontal: true, vertical: false)
								}
								.font(.system(size: 17))
								
								Text("|")
									.foregroundColor(.gray)
									.unredacted()
								
								Text("\(review.updatedAt.getDay())")
									.foregroundColor(.gray)
									.font(.system(size: 13))
							} // HStack
						} // VStack
						
						Spacer()
					} // HStack
					.font(.system(size: 17))
					
					LazyVStack {
						if isLoading {
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
					
					Text(review.description) // 댓글
						.font(.system(size: 15))
						.lineSpacing(8)
						.foregroundColor(Color("textColor"))
				} // VStack
				.padding()
				.background(Color("cellColor"))
				.cornerRadius(8)
				.overlay(RoundedRectangle(cornerRadius: 8)
					.stroke(Color("textColor"), lineWidth: 0.1))
				.onAppear {
					isLoading = true
					Task {
//						print(#function, #line, reportReview)
						review = await reportVM.fetchReviews(reviewId: reportReview.targetId)
						
						let (name, profileId) = await reportVM.fetchReviews(userId: reportReview.userId)
//						print(#line, name, profileId)
						self.userName = name
						self.userProfile = await reportVM.fetchImage(foodCartId: reportReview.userId, imageName: profileId)
//						print(#function, #line, review.imageId)
						for imageId in review.imageId {
							let image = await reportVM.fetchImage(foodCartId: review.id, imageName: imageId)
							imageList.append(image)
						}
						
						isLoading = false
					}
				}
				.navigationDestination(isPresented: $showDetail) {
					ReportDetailView(reportVM: reportVM, report: reportReview)
				}
			} // Button
		} // ZStack
		.padding(.horizontal)
	}
}


struct ReportReviewView_Previews: PreviewProvider {
    static var previews: some View {
		ReportReviewView()
    }
}
