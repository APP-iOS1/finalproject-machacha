//
//  HomeView.swift
//  Collapsable Toolbar SwiftUI
//
//  Created by Towhid on 4/23/22.
//

import SwiftUI

struct ProfileEditView: View {
	//MARK: Property wrapper
	@Environment(\.presentationMode) var presentation
	@EnvironmentObject var profileVM: ProfileViewModel
	@State private var offset: CGFloat = 0
	@State private var imagePickerVisible: Bool = false
	@State private var profileImage: UIImage?
	
	//MARK: Property
	let maxHeight = Screen.maxHeight * 0.35
	
	var body: some View {
		GeometryReader{ proxi in
			let topEdge = proxi.safeAreaInsets.top
			ProfileContentView(topEdge: topEdge)
				.edgesIgnoringSafeArea(.top)
				.navigationBarBackButtonHidden()
				.onAppear {
					profileImage = profileVM.profileImage
				}
		}
		.sheet(isPresented: $imagePickerVisible) {
			MyUIImagePicker(imagePickerVisible: $imagePickerVisible, selectedImage: $profileImage)
		}
		.overlay {
			if profileVM.isLoading { // 네트워크 통신의 로딩
				ZStack {
					Color(white: 0, opacity: 0.75)
					ProgressView()
						.scaleEffect(3)
						.tint(.white)
				}
				.ignoresSafeArea()
			}
		}
	}
	
	@ViewBuilder
	private func ProfileContentView(topEdge: CGFloat) -> some View {
		ScrollView(.vertical , showsIndicators: false) {
			VStack(spacing: 0) {
				GeometryReader{ proxy in
					UserProfile(topEdge: topEdge)
						.foregroundColor(.white)
						.frame(maxWidth: .infinity)
						.frame(height: getHeaderHeight(topEdge: topEdge) , alignment: .bottom)
						.background(Color("Color3"))
						.overlay(CustomNavigationBar(topEdge: topEdge), alignment: .top)
				}
				.frame(height: maxHeight)
				.offset(y: -offset)
				.zIndex(1)

				VStack(spacing: 25) {
					SectionHeaderView(name: "이름")
					VStack(spacing: 50) {
						TextField("", text: $profileVM.name)
							.modifier(TextFieldClearButton(text: $profileVM.name))
							.placeholder(when: profileVM.name.isEmpty) {
								Text("사용할 이름을 알려주세요")
									.foregroundColor(Color("Color3"))
									.frame(height: 35)
							}
							.padding()
							.background(Color("cellColor"))
							.cornerRadius(20)
							.frame(height: 35)
						
						UserLogout() // 로그아웃, 회원탈퇴
					}
					.zIndex(0)
				}
				.padding()
				
			}.modifier(OffsetModifier(offset: $offset))
		}
		.coordinateSpace(name: "SCROLL")
		.background(Color("bgColor"))
	}
	
	@ViewBuilder
	private func CustomNavigationBar(topEdge: CGFloat) -> some View {
		HStack(spacing: 16) {
			Button {
				self.presentation.wrappedValue.dismiss()
			} label: {
				Image(systemName: "chevron.left")
					.resizable()
					.scaledToFit()
					.frame(width: 10)
			}
			
			HStack(spacing: 16) {
				VStack {
					if let image = profileImage {
						Image(uiImage: image)
							.resizable()
							.cornerRadius(50)
					} else {
						RoundedRectangle(cornerRadius: 50)
							.foregroundColor(Color("bgColor"))
					}
				} // VStack
				.frame(width: 35, height: 35)
				.overlay(RoundedRectangle(cornerRadius: 50)
						.stroke(Color("bgColor"), lineWidth: 2))
				.opacity(topBarTitleOpacity(topEdge: topEdge))
				
				Text(profileVM.currentUser?.email ?? "")
					.font(.machachaSubheadBold)
					.foregroundColor(Color("cellColor"))
					.opacity(topBarTitleOpacity(topEdge: topEdge))
			} // HStack

			Spacer()
			
			Button {
				if let profileImage = profileImage {
					profileVM.isLoading = true
					Task {
						let result = await profileVM.updateUser(uiImage: profileImage, name: profileVM.name)
						profileVM.isLoading = false
						
						if result { // 성공일 경우
							self.profileVM.profileImage = profileImage // UI Update
							self.presentation.wrappedValue.dismiss()
						}
					}
				}
			} label: {
				Text("수정")
			}
		}
		.overlay {
			Text("프로필 수정")
				.bold()
				.opacity(getOpacity())
		}
		.padding(.horizontal)
		.frame(height: 70)
		.foregroundColor(.white)
		.padding(.top, topEdge - 20) // 임시
	}
	
	@ViewBuilder
	private func UserLogout() -> some View {
		HStack(spacing: 20) {
			Button {
				profileVM.isLoading = true
				Task {
					try await profileVM.logout()
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 임ㅅ
						profileVM.isLoading = false
						profileVM.currentUser = nil
						self.presentation.wrappedValue.dismiss()
					}
				}
			} label: {
				Text("로그아웃")
					.underline()
			}
			Divider()
			
			NavigationLink {
				ProfileSecessionView(parentsView: self)
			} label: {
				Text("회원탈퇴")
					.underline()
			}
		}
		.foregroundColor(.secondary)
		.font(.machachaFootnote)
	}

	func getHeaderHeight(topEdge: CGFloat) -> CGFloat{
		let topHeight = maxHeight + offset
		return topHeight > (60 + topEdge) ? topHeight : (60 + topEdge )
	}

	func topBarTitleOpacity(topEdge: CGFloat) -> CGFloat {
		let progress = -(offset + 20) / (maxHeight - (60 + topEdge))
		return progress
	}
}

//MARK: - User Profile View
extension ProfileEditView {
	@ViewBuilder
	private func UserProfile(topEdge: CGFloat) -> some View {
		VStack(spacing: 15) {
			VStack {
				if let image = profileImage {
					Image(uiImage: image)
						.resizable()
						.cornerRadius(50)
				} else {
					RoundedRectangle(cornerRadius: 50)
						.foregroundColor(Color("bgColor"))
				}
			} // VStack
			.frame(width: 100, height: 100)
			.overlay(RoundedRectangle(cornerRadius: 50)
					.stroke(Color("cellColor"), lineWidth: 5))
			.overlay {
				Button {
					imagePickerVisible.toggle()
				} label: {
					Circle()
						.scaleEffect(0.3)
						.foregroundColor(Color("Color3"))
						.overlay {
							Image(systemName: "camera.circle")
								.scaleEffect(1.5)
						}
				}
				.offset(x: 40, y: 35)
			}
			
			Text(profileVM.currentUser?.email ?? "")
				.font(.machachaSubhead.bold())
				.foregroundColor(.white)
		} // VStack
		.scaleEffect(getSize(topEdge: topEdge))
		.padding()
		.padding(.bottom)
		.opacity(getOpacity())
	}

	// Opecity 계산
	func getOpacity() -> CGFloat {
		let progress = -offset / 40
		let opacity = 1 - progress

		return offset < 0 ? opacity : 1
	}
	
	// Size 계산
	func getSize(topEdge: CGFloat) -> CGSize {
		let progress = offset / (getHeaderHeight(topEdge: topEdge))

		return CGSize(width: progress + 1, height: progress + 1)
	}
}

struct ProfileEditView_Previews: PreviewProvider {
	static var previews: some View {
		let profileVM = ProfileViewModel()

		NavigationView {
			ProfileEditView()
				.environmentObject(profileVM)
				.onAppear {
					profileVM.currentUser = User.getDummy()
			}
		}
	}
}
