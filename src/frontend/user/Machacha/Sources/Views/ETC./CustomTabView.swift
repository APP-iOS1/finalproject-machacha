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
	static let shared = TabBarManager() // Singleton
	
	// PlusTab에서 이전으로 돌아가기 위한 값 저장
	@Published var preTabSelection: Tab = .home
	@Published var isShowingModal: Bool = false
	@Published var safeArea: EdgeInsets = EdgeInsets()	// 기기의 safeArea
	
	@Published var showTabBar: Bool = true				// tab을 노출할것인지
	@Published var barOffset: CGFloat = (Screen.maxWidth - 16 * 2) * 0.184 * -2
	@Published var curTabSelection: Tab = .home {
		willSet { // 양 옆 padding: 16 * 2
			switch newValue {
			case .home:		 barOffset = (Screen.maxWidth - 16 * 2) * 0.184 * -2
			case .mapSearch: barOffset = (Screen.maxWidth - 16 * 2) * 0.184 * -1
			case .register:	 barOffset = 0
			case .magazine:  barOffset = (Screen.maxWidth - 16 * 2) * 0.184 * 1
			case .profile: 	 barOffset = (Screen.maxWidth - 16 * 2) * 0.184 * 2
			}
		}
	}
    
    //등록 Alert
    @Published var showToast: Bool = false
	
	let hight: CGFloat = Screen.maxHeight * 0.10	// Tab의 높이
}

struct CustomTabView: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@ObservedObject var tabbarManager = TabBarManager.shared
    //MARK: Property wrapper
    @AppStorage("language") private var language = LocalizationViewModel.shared.language
	
    
	var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 0) {
				Spacer()
				Divider()
				HStack(spacing: 0) {
					ForEach(0..<5) { index in
						Button {
							switch index {
							case 0: tabbarManager.curTabSelection = .home
							case 1: tabbarManager.curTabSelection = .mapSearch
							case 2: tabbarManager.isShowingModal = true
							case 3: tabbarManager.curTabSelection = .magazine
							default: tabbarManager.curTabSelection = .profile
							}
							
							if index != 2 { // plus 버튼을 제외하고 이전 상태값 저장
								tabbarManager.preTabSelection = tabbarManager.curTabSelection
							}
						} label: {
							VStack {
								switch index {
                                case 0: TabButton(isSelection: tabbarManager.curTabSelection == .home, name: "맛집찾기".localized(language), systemName: "fork.knife.circle.fill", systemNameByNotSelected: "fork.knife.circle")
								case 1:
									TabButton(isSelection: tabbarManager.curTabSelection == .mapSearch, name: "검색".localized(language), systemName: "magnifyingglass.circle.fill", systemNameByNotSelected: "magnifyingglass.circle")
								case 2: PlusTabButton(isSelection: tabbarManager.curTabSelection == .register, name: "", systemName: "plus.circle.fill")
								case 3: TabButton(isSelection: tabbarManager.curTabSelection == .magazine, name: "매거진".localized(language), systemName: "newspaper.circle.fill", systemNameByNotSelected: "newspaper.circle")
								default: TabButton(isSelection: tabbarManager.curTabSelection == .profile, name: "내정보".localized(language), systemName: "person.circle.fill", systemNameByNotSelected: "person.circle")
								}
							} // VStack
							.padding(.horizontal, 20) // 버튼 영역까지 고려
							.offset(y: UIDevice.hasNotch ? 10 : 0) // Safe Area(has Notch) + Button 영역을 고려한 수치
						} // Button
					} //ForEach
				} // HStack
				.padding(.bottom, tabbarManager.safeArea.bottom) // 버튼 영역까지 고려
				.frame(width: Screen.maxWidth, height: tabbarManager.hight)
				.overlay {
					VStack {
						Rectangle()
							.foregroundColor(tabbarManager.curTabSelection == .register ? .clear : Color("Color3"))
							.frame(width: Screen.maxWidth * 0.15, height: 2)
							.offset(x: tabbarManager.barOffset)
							.animation(.spring(), value: tabbarManager.barOffset)
						Spacer()
					} // VStack
				}
			}
		} // VStack
	}
}

//MARK: - TabButton
struct TabButton: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@ObservedObject var tabbarManager = TabBarManager.shared

	//MARK: Property
	let isSelection: Bool 	// 현재 Tab
	let name: String		// Tab 이름
	let systemName: String 	// 선택되었을때
	let systemNameByNotSelected: String // 선택되지 않았을때
	
	var body: some View {
		VStack(spacing: 7) {
			Image(systemName: isSelection ? systemName : systemNameByNotSelected)
				.resizable()
				.scaledToFit()
				.frame(width: 23)
				.fixedSize()

			Text(name)
				.font(.machachaCaption)
		} // VStack
		.fixedSize(horizontal: true, vertical: false) // View의 크기를 동일한 너비/높이
		.frame(width: Screen.maxWidth / 15)
		.foregroundColor(isSelection ? Color("Color3") : profileVM.isDarkMode ? .white : .gray)
	}
}

//MARK: - Plus TabButton
struct PlusTabButton: View {
	//MARK: Property Wrapper
	@ObservedObject var tabbarManager = TabBarManager.shared

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
		} // VStack
		.frame(width: Screen.maxWidth / 15)
	}
}

struct CustomTabView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			Color("bgColor")
			
			CustomTabView()
				.environmentObject(ProfileViewModel())
		}
	}
}
