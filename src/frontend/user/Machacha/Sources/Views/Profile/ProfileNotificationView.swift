//
//  ProfileNotificationView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import SwiftUI

struct ProfileNotificationView: View {
	//MARK: Property Wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@Environment(\.presentationMode) var presentation
	@ObservedObject var tabbarManager = TabBarManager.shared
	@State private var showNoti = false
	@State private var selectNoti: UserNotification = UserNotification.getDummy()

	//MARK: Property
	let userNoti: [UserNotification]
	var periodArr = ["오늘", "이번 주", "이번 달", "오래된 알림"]
	// notification 내 createdAt 기준 날짜 필터링
	var today: [UserNotification] { userNoti.filter { $0.getIntervalTime >= 0 && $0.getIntervalTime < 86400 }}
	var thisWeek: [UserNotification] { userNoti.filter { $0.getIntervalTime >= 86400 && $0.getIntervalTime < 604800 }}
	var thisMonth: [UserNotification] { userNoti.filter { $0.getIntervalTime >= 604800 && $0.getIntervalTime < 2592000 }}
	var old: [UserNotification] { userNoti.filter { $0.getIntervalTime >= 2592000 }}

    var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack {
				ForEach(periodArr.indices, id: \.self) { i in
					LazyVStack(spacing: 0) {
						if getPeriodType(periodArr[i]).count > 0 { // 해당 기간에 없으면 표시 X
							Rectangle()
								.foregroundColor(Color("Color3").opacity(0.3))
								.frame(height: 8)
							VStack {
								Text("\(periodArr[i])")
									.font(.machachaFootnote)
									.foregroundColor(Color(hex: "999899"))
									.frame(maxWidth: .infinity, alignment: .leading)
							} // VStack
							.padding([.leading, .top], 16)
							.background(Color("cellColor"))
						}
						
						ForEach(getPeriodType(periodArr[i]), id: \.self) { notification in
							ProfileNotificationCellView(notification: notification)
						} // ForEach
					} // LazyVStack
					.cornerRadius(8)
					.overlay(RoundedRectangle(cornerRadius: 8)
						.stroke(Color("textColor"), lineWidth: 0.1))
				} // ForEach
			} // LazyVStack
			.padding()
		} // ScrollView
		.background(Color("bgColor"))
		.scrollContentBackground(.hidden)
		.navigationBarBackButtonHidden()
		.navigationBarTitle("공지 및 알림".localized(language), displayMode: .inline)
		.toolbarBackground(Color("Color3"), for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
		.toolbar(content: {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					self.presentation.wrappedValue.dismiss()
				} label: {
					Image(systemName: "chevron.left")
				}
			} // ToolbarItem
		})
    }
	
	func getPeriodType(_ periodType: String) -> [UserNotification] {
		switch periodType {
		case "오늘":
			return today
		case "이번 주":
			return thisWeek
		case "이번 달":
			return thisMonth
		default:
			return old
		}
	}
}

extension ProfileNotificationView {
	@ViewBuilder
	private func ProfileNotificationCellView(notification: UserNotification) -> some View {
		Button {
			switch notification.navigationType {
			case "all":
				self.selectNoti = notification
				self.showNoti.toggle()
			case "home":
				self.presentation.wrappedValue.dismiss() // 이전 화면으로 이동후
				self.tabbarManager.curTabSelection = .home
				tabbarManager.barOffset = tabbarManager.offsetList[0]
			case "search":
				self.presentation.wrappedValue.dismiss() // 이전 화면으로 이동후
				self.tabbarManager.curTabSelection = .mapSearch
				tabbarManager.barOffset = tabbarManager.offsetList[1]
			case "magazine":
				self.presentation.wrappedValue.dismiss() // 이전 화면으로 이동후
				self.tabbarManager.curTabSelection = .magazine
				tabbarManager.barOffset = tabbarManager.offsetList[3]
			default:
				self.presentation.wrappedValue.dismiss() // 이전 화면으로 이동후
			}
		} label: {
			HStack(alignment: .top) {
				RoundedRectangle(cornerRadius: 8)
					.foregroundColor(Color("bgColor"))
					.frame(width: 50, height: 50)
					.overlay {
						VStack {
							switch notification.navigationType {
							case "all":
								Image(systemName: "mic")
							case "home":
								Image(systemName: "fork.knife")
							case "search":
								Image(systemName: "magnifyingglass")
							case "magazine":
								Image(systemName: "newspaper")
							default:
								Image(systemName: "bell")
							}
						} // VStack
						.foregroundColor(Color("textColor"))
					}
				Spacer()
				
				HStack(alignment: .top) {
					HStack {
						switch notification.navigationType {
						case "all":
							CustomBoldLabelView(text1: " 새로운 ", text2: "이 있어요.", user: "\(notification.contents)", task: "공지사항")
						case "home":
							CustomBoldLabelView(text1: " 에서 새로운 ", text2: "을 알아보세요.", user: "맛집찾기", task: "추천 맛집")
						case "search":
							CustomBoldLabelView(text1: " 에 새롭게 추가된 ", text2: "를 발견했어요.", user: "내 동내", task: "포장마차")
						case "magazine":
							CustomBoldLabelView(text1: " 님이 추천하는 새로운 ", text2: "이 올라왔어요.", user: "마차챠 인프로언서", task: "매거진")
						default:
							CustomBoldLabelView(text1: " 의 새로운 ", text2: "이 있어요.", user: "마차챠", task: "알림")
						}
					}
					
					Text("\(notification.descriptionDate)")
						.font(.machachaFootnote)
						.foregroundColor(.secondary)
				} // HStack
				.frame(height: 40)
			}
			.padding(.horizontal)
			.frame(height: 64)
			.background(Color("cellColor"))
		} // Button
		.navigationDestination(isPresented: $showNoti) {
			ProfileAppNotificationView(noti: selectNoti)
		}
	}
}

struct ProfileNotificationView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			ProfileNotificationView(userNoti: UserNotification.getDummyList())
		}
    }
}
