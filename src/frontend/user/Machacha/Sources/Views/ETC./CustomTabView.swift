//
//  CustomTabView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

enum Tab {
	case home
	case mapSearch
	case register
	case magazine
	case profile
}

class TabBarManager: ObservableObject {
	@Published var showTabBar: Bool = true
	@Published var curTabSelection: Tab = .home
	@Published var preTabSelection: Tab = .home
	@Published var barOffset: CGFloat = -139
	@Published var bottomPadding: CGFloat = Screen.maxHeight * 0.10
    @Published var isShowingModal: Bool = false
    @Published var preIndex: Int = 0

	static let shared = TabBarManager() // Singleton
	
	let offsetList: [CGFloat] = [-139, -68, 4, 76, 144]
}

struct CustomTabView: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@ObservedObject var tabbarManager = TabBarManager.shared
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			VStack {
				HStack(alignment: .center, spacing: 8) {
					ForEach(0..<5) { index in
						Spacer().frame(width: Screen.maxWidth * 0.02)
						
						Button {
                            switch index {
                            case 0: tabbarManager.curTabSelection = .home
                            case 1: tabbarManager.curTabSelection = .mapSearch
                            case 2: tabbarManager.isShowingModal = true
                            case 3: tabbarManager.curTabSelection = .magazine
                            default: tabbarManager.curTabSelection = .profile
                            }
                            
							if index != 2 {
								tabbarManager.preTabSelection = tabbarManager.curTabSelection
                                tabbarManager.preIndex = index
                                print(tabbarManager.preIndex)
							}
							
                            tabbarManager.barOffset = tabbarManager.offsetList[index]
						} label: {
							switch index {
							case 0: TabButton(isSelection: tabbarManager.curTabSelection == .home, name: "맛집찾기", systemName: "fork.knife.circle.fill", systemNameByNotSelected: "fork.knife.circle")
							case 1:
								TabButton(isSelection: tabbarManager.curTabSelection == .mapSearch, name: "검색", systemName: "magnifyingglass.circle.fill", systemNameByNotSelected: "magnifyingglass.circle")
							case 2: PlusTabButton(isSelection: tabbarManager.curTabSelection == .register, name: "", systemName: "plus.circle.fill")
							case 3: TabButton(isSelection: tabbarManager.curTabSelection == .magazine, name: "매거진", systemName: "newspaper.circle.fill", systemNameByNotSelected: "newspaper.circle")
							default: TabButton(isSelection: tabbarManager.curTabSelection == .profile, name: "내정보", systemName: "person.circle.fill", systemNameByNotSelected: "person.circle")
							}
						} // Button
						Spacer().frame(width: Screen.maxWidth * 0.02)
					} //ForEach
					.frame(height: 85) // 기기마다 같은 Tab 크기
					.edgesIgnoringSafeArea(.all)
				} // HStack
				.frame(width: Screen.maxWidth)
				.clipShape(RoundedRectangle(cornerRadius: 22))
				.overlay {
					RoundedRectangle(cornerRadius: 22)
						.stroke(.gray, lineWidth: 2)

					Rectangle()
						.foregroundColor(tabbarManager.curTabSelection == .register ? .black : .red)
						.frame(width: Screen.maxWidth * 0.15, height: 3)
						.offset(x: tabbarManager.barOffset, y: -Screen.maxHeight * 0.10/2)
						.animation(.spring(), value: tabbarManager.barOffset)
				}
			} // VStack
			.edgesIgnoringSafeArea([.bottom])
			.onAppear {
				tabbarManager.bottomPadding = Screen.maxHeight * 0.10
			}
		} // VStack
	}
}

//MARK: - TabButton
struct TabButton: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel

	//MARK: Property
	let isSelection: Bool 	// 현재 Tab
	let name: String		// Tab 이름
	let systemName: String 	// 선택되었을때
	let systemNameByNotSelected: String // 선택되지 않았을때
	
	var body: some View {
		VStack(spacing: 5) {
			Image(systemName: isSelection ? systemName : systemNameByNotSelected)
				.resizable()
				.scaledToFit()
				.frame(width: 25)
			Text(name)
				.font(.custom("Pretendard-Medium", size: 11))
			Spacer()
		} // VStack
		.padding(.vertical, 17)
		.foregroundColor(isSelection ? Color("Color3") : profileVM.isDarkMode ? .white : .gray)
	}
}

//MARK: - Plus TabButton
struct PlusTabButton: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	
	//MARK: Property
	let isSelection: Bool 	// 현재 Tab
	let name: String		// Tab 이름
	let systemName: String 	// 선택되었을때
	
	var body: some View {
		VStack {
			Image(systemName: systemName)
				.resizable()
				.scaledToFit()
				.frame(width: 40)
				.foregroundColor(Color("Color3"))
			Spacer()
		} // VStack
		.padding(.vertical, 17)
	}
}

struct CustomTabView_Previews: PreviewProvider {
	static var previews: some View {
		CustomTabView()
			.environmentObject(ProfileViewModel())
	}
}
