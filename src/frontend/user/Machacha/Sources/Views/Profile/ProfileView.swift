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
	let settings: [SettingType] = [.profile, .faceID, .alert, .darkMode, .language]
	let webInfo: [WebInfoType] = [.privacy, .openSource, .license]
	
	var body: some View {
		NavigationView {
			List {
				if let user = profileVM.currentUser { // 사용자 정보
					VStack(alignment: .leading) {
						Text(user.name)
							.font(.title3)
					} // VStack
					.padding([.top, .bottom], 10)
				} else { // 로그인 요청 버튼
					Button {
						profileVM.showLogin = true
					} label: {
						Text("로그인")
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .center)
					} // Button
				} // if let user = userStateVM.currentUser
				
				SettingSection() // Setting Section
				
				WebViewSection() // WebView Section
				
				if profileVM.currentUser != nil {
					Button(role: .destructive) {
						Task {
							try await profileVM.logout()
							profileVM.showLogin = true
						}
					} label: {
						Text("로그아웃")
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .center)
					} // Button
				} // userStateVM.currentUser != nil
			} // List
			.navigationTitle("프로필")
		} // NavigationView
	}
	
	// Setting Section
	@ViewBuilder
	private func SettingSection() -> some View {
		Section {
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
					}
				} // else
			} // ForEach
		} header: {
			Text("설정")
		} // Section
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
			ForEach(Array(webInfo.enumerated()), id: \.offset) { i, web in
				Button {
					self.showSafari = i // 선택된 Web Safari 정보
				} label: {
					Text("\(web.display)")
						.fixedSize(horizontal: false, vertical: true)
						.frame(maxWidth: .infinity, alignment: .leading)
				} // Button
			} // ForEach
		} header: {
			Text("Machacha 정보")
		} // Section
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
