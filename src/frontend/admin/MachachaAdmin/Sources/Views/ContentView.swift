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
				
				MagazineView()
					.tabItem {
						Image(systemName: "newspaper.fill")
						Text("매거진")
					}.tag(Tab.magazine)
				
				NoticeView()
					.tabItem {
						Image(systemName: "bell.fill")
						Text("공지")
					}.tag(Tab.notice)
				
				ProfileView()
					.tabItem {
						Image(systemName: "person.fill")
						Text("프로필")
					}.tag(Tab.profile)
			} // TabView
			.navigationBarTitle(selection.title)
			.toolbarBackground(Color.accentColor, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
		} // NavigationStack
	}
}

enum Tab: Int {
	case approve = 1
	case report = 2
	case magazine = 3
	case notice = 4
	case profile = 5
	
	var title: String {
		switch self {
		case .approve:
			return "가게 승인"
		case .report:
			return "신고 누적 가게"
		case .magazine:
			return "매거진 작성"
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
