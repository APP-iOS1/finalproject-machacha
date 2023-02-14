//
//  ContentView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ContentView: View {
	//MARK: Property Wrapper
	@State private var selection = Tab.approve

	//MARK: Property
	
	var body: some View {
		NavigationStack {
			TabView(selection: $selection) {
				ApproveView()
					.tabItem {
						Image(systemName: "plus.circle.fill")
						Text("승인")
					}.tag(Tab.approve)
				
				ReportView()
					.tabItem {
						Image(systemName: "light.beacon.max.fill")
						Text("신고")
					}.tag(Tab.report)
				
				ReportReviewView()
					.tabItem {
						Image(systemName: "newspaper.fill")
						Text("리뷰신고")
					}.tag(Tab.reportReview)
				
				NoticeView()
					.tabItem {
						Image(systemName: "bell.fill")
						Text("공지")
					}.tag(Tab.notice)
//
//				ProfileView()
//					.tabItem {
//						Image(systemName: "person.fill")
//						Text("프로필")
//					}.tag(Tab.profile)
			} // TabView
		} // NavigationStack
	}
}

enum Tab: Int {
	case approve = 1
	case report = 2
	case reportReview = 3
	case notice = 4
	case profile = 5
	
	var title: String {
		switch self {
		case .approve:
			return "가게 승인"
		case .report:
			return "신고 누적 가게"
		case .reportReview:
			return "리뷰 신고"
		case .notice:
			return "전체 알림"
		case .profile:
			return "프로필"
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
