//
//  ProfileSecessionView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/02/05.
//

import SwiftUI

struct ProfileSecessionView: View {
	//MARK: Property wrapper
	@AppStorage("language") private var language = LocalizationViewModel.shared.language
	@Environment(\.presentationMode) var presentation
	@EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var authVM: AuthViewModel
	@State private var isCheck = false // 위 내용을 확인했는지?
	@State private var isAlert = false // 마지막 알림

	//MARK: Property
	let parentsView: ProfileEditView
	let cautionContents: [String] = ["마차챠 내 자료 열람이 차단됩니다.", "계정 삭제 전 필요한 자료를 다운 받는 것을 권장합니다.", "계정을 삭제하면, 마차챠내 모든 자료의 열람이 차단되며, 복구가 불가능합니다.", "계정 삭제 전 신중하게 선택해 주시기 바랍니다."]

	var body: some View {
		VStack {
			VStack {
				CautionTitle()		// 주의사항 Title
				CautionContents()	// 주의사항 내용
				CautionCheck()		// 주의사항 사용자 확인
			} // VStack
			.padding()
			Spacer()
			UserSecession()			// 계정 삭제 버튼
		} // VStack
		.background(Color("bgColor"))
		.navigationBarBackButtonHidden()
		.navigationBarTitle("회원탈퇴".localized(language), displayMode: .inline)
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
		.alert(isPresented: $isAlert) {
			Alert(
				title: Text("마지막 인사".localized(language)),
				message: Text("그동안 즐거웠어요. 다음에 봐요!".localized(language)),
				primaryButton: .default(Text("취소".localized(language))) {},
				secondaryButton: .destructive(Text("확인".localized(language))) {
                    //회원탈퇴
                    authVM.deleteAuth()
				})
		}
	}
	
	// 주의사항 Title
	@ViewBuilder
	private func CautionTitle() -> some View {
		HStack(spacing: 8) {
			Image(systemName: "exclamationmark.circle.fill")
				.foregroundColor(Color("Color3"))
			Text("계정을 삭제하기 전에 꼭 확인해 주세요!")
				.font(.machachaFootnoteBold)
				.foregroundColor(Color("textColor"))
			Spacer()
		} // HStack
		.padding()
		.fixedSize(horizontal: false, vertical: true)
		.frame(maxWidth: .infinity, alignment: .center)
		.background(Color("Color3").opacity(0.3)) // 계정삭제 활성화 UI
		.cornerRadius(8)
		.overlay(RoundedRectangle(cornerRadius: 8)
			.stroke(Color("Color1"), lineWidth: 0.1))
	}
	
	// 주의사항 내용
	@ViewBuilder
	private func CautionContents() -> some View {
		VStack(alignment: .leading, spacing: 8) {
			ForEach(cautionContents, id: \.self) { content in
				HStack(alignment: .top) {
					Text("◦").offset(y: -5)
					Text(content)
						.font(.machachaFootnote)
						.foregroundColor(Color("textColor"))
						.lineSpacing(8)
				} // HStack
			} // ForEach
		} // VStack
		.padding()
		.fixedSize(horizontal: false, vertical: true)
		.frame(maxWidth: .infinity, alignment: .center)
		.background(Color("cellColor"))
		.cornerRadius(8)
		.overlay(RoundedRectangle(cornerRadius: 8)
			.stroke(Color("textColor"), lineWidth: 0.1))
	}
	
	// 주의사항 확인
	@ViewBuilder
	private func CautionCheck() -> some View {
		Button {
			isCheck.toggle()
		} label: {
			HStack(spacing: 8) {
				Image(systemName: isCheck ? "checkmark.circle.fill" : "checkmark.circle")
					.foregroundColor(isCheck ? Color("Color5") : .gray)
				Text("위 내용을 모두 확인했습니다.")
					.font(.machachaFootnote)
					.foregroundColor(Color("textColor"))
				Spacer()
			} // HStack
			.padding()
			.fixedSize(horizontal: false, vertical: true)
			.frame(maxWidth: .infinity, alignment: .center)
			.background(Color("cellColor"))
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8)
				.stroke(Color("textColor"), lineWidth: 0.1))
		}
	}
	
	// User 계정 삭제
	@ViewBuilder
	private func UserSecession() -> some View {
		VStack {
			Button(role: .destructive) { // disabled의 색상도 자동변경
				self.isAlert.toggle()
			} label: {
				Text("계정삭제")
					.fixedSize(horizontal: false, vertical: true)
					.frame(maxWidth: .infinity, alignment: .center)
				
			} // Button
			.padding()
			.background(isCheck ? Color("cellColor") : Color(uiColor: .lightGray)) // 계정삭제 활성화 UI
			.disabled(!isCheck) // 계정삭제 버튼 활성화
			.cornerRadius(8)
			.overlay(RoundedRectangle(cornerRadius: 8)
				.stroke(Color("textColor"), lineWidth: 0.1))
		} // VStack
		.padding()
	}
}

struct ProfileSecessionView_Previews: PreviewProvider {
    static var previews: some View {
		let profileVM = ProfileViewModel()

		NavigationView {
			ProfileSecessionView(parentsView: ProfileEditView())
				.environmentObject(profileVM)
				.onAppear {
					profileVM.currentUser = User.getDummy()
			}
		}
    }
}
