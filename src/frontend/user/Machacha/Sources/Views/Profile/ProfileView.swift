//
//  ProfileView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct ProfileView: View {
	//MARK: Property wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@EnvironmentObject var profileVM: ProfileViewModel
	@StateObject var faceIDVM = FaceIDViewModel()
	@State private var showSafari: Int?
	
	//MARK: Property
	let profileInfo: [FoodCartOfUserType] = [.favorite, .visited, .review, .register]
	let settings: [SettingType] = [.faceID, .alert, .darkMode, .language]
	let webInfo: [WebInfoType] = [.privacy, .openSource, .license]

	var body: some View {
		NavigationView {
			ScrollView {
				UserLoginStatus() // User Login Status
				
				SettingSection() // Setting Section
				
				WebViewSection() // WebView Section
			}
			.background(Color("bgColor"))
			.onAppear {
				UserDefaults.standard.set("egmqxtTT1Zani0UkJpUW", forKey: "userIdToken") // 임시: 로그인시
				Task {
					profileVM.currentUser = try await profileVM.fetchUser()
					profileVM.name = profileVM.currentUser?.name ?? ""
					profileVM.reviewUser = try await profileVM.fetchReivews()
					profileVM.profileImage = try await profileVM.fetchImage(foodCartId: profileVM.currentUser!.id, imageName: profileVM.currentUser!.profileId)
				} // Task
			} // ScrollView
			.navigationBarTitle("프로필".localized(language), displayMode: .inline)
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink {
						ProfileNotificationView() // 알림 및 공지사항
					} label: {
						Image(systemName: "bell.badge")
							.symbolRenderingMode(.multicolor)
							.foregroundStyle(.orange)
					}
				} // ToolbarItem
			})
		} // NavigationView
	}
}

//MARK: - 유저 Login/Logout 상태일때 보이거나 사라지는 View
extension ProfileView {
	// User Login Status - FoodCart List By User Action
	@ViewBuilder
	private func UserLoginStatus() -> some View {
		if let user = profileVM.currentUser { 	// 사용자 정보
			VStack(spacing: 0) {
				UserProfile(user)
				Divider() // Profile View 로그인 부분과 구분
				UserFoodCart(user)
				Divider() // View가 끝나는 부분
			} // VStack
		} else { 								// 로그인 요청 버튼
			VStack {
				Button {
					profileVM.showLogin = true
					profileVM.currentUser = User.getDummy() // 임시: 로그인 했다고 임시로 가정
				} label: {
					Text("로그인".localized(language))
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
	}
	
	// User Profile View
	@ViewBuilder
	private func UserProfile(_ user: User) -> some View {
		NavigationLink {
			ProfileEditView()
		} label: {
			HStack {
				VStack(alignment: .leading, spacing: 8) {
					Text("우리 자주 만나요!".localized(language))
						.font(.machachaHeadline)
					HStack(spacing: 16) {
						VStack {
							if let image = profileVM.profileImage {
								Image(uiImage: image)
									.resizable()
									.cornerRadius(8)
									.overlay(RoundedRectangle(cornerRadius: 8)
											.stroke(Color("bgColor"), lineWidth: 2))
							} else {
								RoundedRectangle(cornerRadius: 8) // 임시
									.foregroundColor(Color("bgColor"))
							}
						} // VStack
						.frame(width: 40, height: 40)

						VStack(alignment: .leading) {
							HStack {
								Text(user.name)
									.font(.machachaTitleBold)
								Text("님".localized(language))
									.font(.machachaHeadline)
							} // HStack
							.overlay { // 이름 아래 형광색 밑줄
								RoundedRectangle(cornerRadius: 2)
									.foregroundColor(profileVM.isDarkMode ? Color("Color2").opacity(0.3) : Color("Color3").opacity(0.2))
									.frame(height: 10)
									.offset(y: 8)
							}
							Text(user.email.maskEmail())
								.font(.machachaFootnote)
								.foregroundColor(.secondary)
						} // VStack
					} // HStack
				} // VStack
				Spacer()
				Image(systemName: "chevron.right")
					.foregroundColor(.gray)
			} // HStack
			.padding()
			.foregroundColor(Color("textColor"))
			.frame(maxWidth: .infinity)
			.background(Color("cellColor"))
		}
	}
	
	// User FoodCart View
	@ViewBuilder
	private func UserFoodCart(_ user: User) -> some View {
		HStack(spacing: 0) {
			ForEach(profileInfo, id: \.self) { info in
				NavigationLink {
					ProfileFoodCartListView(foodCartOfUserType: info)
				} label: {
					HStack(spacing: 0) {
						VStack(spacing: 10) {
							Image(systemName: info.image)
								.resizable()
								.scaledToFit()
								.frame(width: 20)
								.foregroundColor(info.color)
								.overlay {
									Image(systemName: info.badge)
										.resizable()
										.scaledToFit()
										.frame(width: 10)
										.offset(x: -9, y: 8)
										.foregroundColor(info.color)
								}
							Text(info.display.localized(language))
								.font(.machachaSubhead)
								.foregroundColor(Color("textColor"))
						} // VStack
						.padding(.horizontal)
					} // HStack
				} // NavigationLink
				if info != .register { // 각 항목과 구분
					Divider().frame(height: 45)
				}
			} // ForEach
		} // HStack
		.padding()
		.fixedSize(horizontal: true, vertical: false)
		.frame(maxWidth: .infinity, alignment: .center)
		.background(Color("cellColor"))
	}
}

//MARK: - ProfileView의 Settings와 WebView List Section View
extension ProfileView {
	// Setting Section
	@ViewBuilder
	private func SettingSection() -> some View {
		Section {
			VStack(alignment: .leading, spacing: 15) {
				ForEach(settings, id: \.self) { setting in
					switch setting {
					case .faceID:
						HStack {
							Image(systemName: setting.image)
							Toggle(setting.display.localized(language), isOn: $profileVM.isFaceID)
						}
					case .alert:
						HStack {
							ZStack {
								RoundedRectangle(cornerRadius: 5)
									.trim(to: profileVM.isAlert ? 0 : 1)
									.frame(width: 1, height: 20)
									.rotationEffect(.degrees(-45))
									.animation(.easeInOut, value: profileVM.isAlert)
								
								Image(systemName: setting.image)
							}
							
							Toggle(setting.display.localized(language), isOn: $profileVM.isAlert)
						}
					case .darkMode:
						HStack {
							Image(systemName: setting.image)
								.rotationEffect(.degrees(profileVM.isDarkMode ? 90 : 0))
								.animation(.easeOut(duration: 1), value: profileVM.isDarkMode) // 활성화 에니메이션
							Toggle(setting.display.localized(language), isOn: $profileVM.isDarkMode)
						}
					case .language:
						NavigationLink {
							ProfileLanguageView()
						} label: {
							HStack {
								Image(systemName: setting.image)
								
								Text(setting.display.localized(language))
									.font(.machachaCallout)
								Spacer()
								Image(systemName: "chevron.right")
									.foregroundColor(.gray)
							}
						}
					} // switch
				} // ForEach
				.foregroundColor(Color("textColor"))
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(8)
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
				primaryButton: .default(Text("설정".localized(language))) { // 앱 설정으로 이동
					if let appSettring = URL(string: UIApplication.openSettingsURLString) {
						UIApplication.shared.open(appSettring, options: [:], completionHandler: nil)
					}
					profileVM.isFaceID = false
				},
				secondaryButton: .default(Text("확인".localized(language))) {
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
						Image(systemName: web.image)
							.overlay {
								Image(systemName: web.badge)
									.scaleEffect(0.5)
							}
						
						Text("\(web.display)".localized(language))
							.font(.machachaCallout)
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .leading)
						Image(systemName: "link")
							.foregroundColor(.gray)
					} // Button
				} // ForEach
				.foregroundColor(Color("textColor"))
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8)
				.stroke(Color("textCoor"), lineWidth: 0.1))
		} header: {
			SectionHeaderView(name: "Machacha 정보")
		} // Section
		.padding(.horizontal, 10)
		.sheet(item: $showSafari) {
			SafariView(url: URL(string: webInfo[$0].url)!)
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
	//MARK: Property wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language

	//MARK: Property
	var name: String
	
	var body: some View {
		HStack {
			Text(name.localized(language))
				.font(.machachaSubhead)
				.foregroundColor(.secondary)
			Spacer()
		} // HStack
		.padding([.horizontal, .top])
	}
}
