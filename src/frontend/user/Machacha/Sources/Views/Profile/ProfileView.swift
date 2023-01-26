//
//  ProfileView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct ProfileView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
	@StateObject var faceIDVM = FaceIDViewModel()
	@State private var showSafari: Int?

	//MARK: Property
	let profileInfo: [FoodCartOfUserType] = [.favorite, .review, .visited, .register]
	let settings: [SettingType] = [.profile, .faceID, .alert, .darkMode, .language]
	let webInfo: [WebInfoType] = [.privacy, .openSource, .license]
	
	var body: some View {
		NavigationView {
			ScrollView {
				UserLoginStatus() // User Login Status
				
				SettingSection() // Setting Section
				
				WebViewSection() // WebView Section
				
				UserLogoutStatus() // User Logout Status
			}
//			.navigationTitle("프로필")
			.background(Color("bgColor"))
			.onAppear {
				UserDefaults.standard.set("egmqxtTT1Zani0UkJpUW", forKey: "userIdToken") // 임시: 로그인시
				Task {
					profileVM.currentUser = try await profileVM.fetchUser()
					profileVM.reviewUser = try await profileVM.fetchReivews()
				} // Task
			} // ScrollView
		} // NavigationView
	}
	
	// FoodCart List By User Action
	@ViewBuilder
	private func UserLoginStatus() -> some View {
		GeometryReader { geometry in
			if let user = profileVM.currentUser { 	// 사용자 정보
				VStack(alignment: .leading) {
					Spacer()
					VStack(alignment: .leading, spacing: 10) {
						Text(user.name)
							.font(.machachaTitleBold)
						Text(user.email)
							.font(.machachaSubhead)
					} // VStack
					Spacer()
					HStack(spacing: 30) {
						ForEach(profileInfo, id: \.self) { info in
							NavigationLink {
								switch info {
								case .favorite:
									EmptyView()
								case .review:
									EmptyView()
								case .visited:
									EmptyView()
								case .register:
									EmptyView()
								} // switch
							} label: {
								VStack(spacing: 10) {
									HStack {
										Image(systemName: info.image)
										switch info {
										case .favorite:
											Text("\(user.favoriteId.count)")
										case .review:
											Text("\(profileVM.reviewUser.count)")
										case .visited:
											Text("\(user.visitedId.count)")
										case .register: // 임시: 통신 필요
											Text("\(user.favoriteId.count)")
										} // switch
									} // HStack
									Text(info.display)
								} // VStack
								.font(.machachaSubhead)
							} // NavigationLink
							.foregroundColor(Color("textColor"))
						} // ForEach
					} // HStack
				} // VStack
				.padding()
				.frame(
					width: geometry.size.width,
					height: Screen.maxHeight * 0.3
				)
				.background(Color("cellColor"))
			} else { 								// 로그인 요청 버튼
				VStack {
					Button {
						profileVM.showLogin = true
						profileVM.currentUser = User.getDummy() // 임시: 로그인 했다고 임시로 가정
					} label: {
						Text("로그인")
							.font(.machachaSubhead)
							.foregroundColor(Color("textColor"))
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .center)
					} // Button
					.padding()
					.background(Color("cellColor"))
					.cornerRadius(20)
				} // VStack
				.padding()
			} // if let user = userStateVM.currentUser
		} // GeometryReader
		.frame(minHeight: profileVM.currentUser == nil ? Screen.maxHeight * 0.08 : Screen.maxHeight * 0.3)
	}
	
	// Setting Section
	@ViewBuilder
	private func SettingSection() -> some View {
		Section {
			VStack(alignment: .leading, spacing: 15) {
				ForEach(settings, id: \.self) { setting in
					if setting.isToggle {
						Toggle(setting.display, isOn: setting == .faceID ? $profileVM.isFaceID : setting == .alert ? $profileVM.isAlert : $profileVM.isDarkMode) // 다중 삼항 연산자
					} else {
						NavigationLink {
							switch setting {
							case .profile:
								EmptyView()
							case .language:
								EmptyView()
							default:
								EmptyView()
							}
						} label: {
							Text(setting.display)
								.font(.machachaSubhead)
								.foregroundColor(Color("textColor"))
						}
					} // else
				} // ForEach
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(20)
		} header: {
			SectionHeaderView(name: "설정")
		} // Section
		.padding(.horizontal, 10)
		.onChange(of: profileVM.isFaceID) { value in
			if value { faceIDVM.authenticate() }
		} // onChange
		.alert(isPresented: $faceIDVM.showErrorAlert) {
			// 허용안함, FaceID error
			Alert(
				title: Text(faceIDVM.showErrorAlertTitle),
				message: Text(faceIDVM.showErrorAlertMessage),
				primaryButton: .default(Text("설정")) { // 앱 설정으로 이동
					if let appSettring = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(appSettring, options: [:], completionHandler: nil)
					}
					profileVM.isFaceID = false
				},
				secondaryButton: .default(Text("확인")) {
					profileVM.isFaceID = false
				})
		}
	}
	
	// 마차챠에 대한 WebView Section
	@ViewBuilder
	private func WebViewSection() -> some View {
		Section {
			VStack(alignment: .leading, spacing: 30) {
				ForEach(Array(webInfo.enumerated()), id: \.offset) { i, web in
					Button {
						self.showSafari = i // 선택된 Web Safari 정보
					} label: {
						Text("\(web.display)")
							.font(.machachaCallout)
							.foregroundColor(Color("textColor"))
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .leading)
					} // Button
				} // ForEach
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(20)
		} header: {
			SectionHeaderView(name: "Machacha 정보")
		} // Section
		.padding(.horizontal, 10)
		.sheet(item: $showSafari) {
			SafariView(url: URL(string: webInfo[$0].url)!)
		}
	}
	
	// User Logout Status
	@ViewBuilder
	private func UserLogoutStatus() -> some View {
		if profileVM.currentUser != nil {
			VStack {
				Button(role: .destructive) {
					Task {
						try await profileVM.logout()
						profileVM.showLogin = true
					}
					profileVM.currentUser = nil // 임시: 로그아웃 했다고 임시로 가정
				} label: {
					Text("로그아웃")
						.fixedSize(horizontal: false, vertical: true)
						.frame(maxWidth: .infinity, alignment: .center)
				} // Button
				.padding()
				.background(Color("cellColor"))
				.cornerRadius(20)
			} // VStack
			.padding()
		}
	}
}

struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
			.environmentObject(ProfileViewModel())
	}
}

//MARK: - SectionHeaderView
struct SectionHeaderView: View {
	//MARK: Property
	var name: String
	
	var body: some View {
		HStack {
			Text(name)
				.font(.headline)
				.foregroundColor(Color(uiColor: .darkGray))
			Spacer()
		} // HStack
		.padding([.horizontal, .top])
	}
}
