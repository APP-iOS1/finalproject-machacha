//
//  ProfileEditView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/26.
//

import SwiftUI

struct ProfileEditView: View {
	//MARK: Property wrapper
	@Binding var user: User
	
	var body: some View {
		ScrollView {
			UserNameSection() // User Name Info
			UserPasswordSection() // User Password Info
		}
		.background(Color("bgColor"))
	}
	
	// User Name Info
	@ViewBuilder
	private func UserNameSection() -> some View {
		VStack {
			VStack(alignment: .leading, spacing: 30) {
				VStack {
					// 이름 Field
					TextField("", text: $user.name)
						.modifier(TextFieldClearButton(text: $user.name))
						.placeholder(when: user.name.isEmpty) {
							Text("이름을 알려주세요").foregroundColor(Color("Color3"))
						}
						.frame(height: 35)
				}
				.padding(.horizontal)
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(20)
		} // VStack
		.padding(.horizontal, 10)
	}
	
	// User Password Info
	@ViewBuilder
	private func UserPasswordSection() -> some View {
		VStack {
			VStack(alignment: .leading, spacing: 30) {
				VStack {
					// 비밀번호 Field
					TextField("", text: $user.name)
						.modifier(TextFieldClearButton(text: $user.name))
						.placeholder(when: user.name.isEmpty) {
							Text("기존 비밀번호를 입력해주세요").foregroundColor(Color("Color3"))
						}
						.frame(height: 35)
					
					// 비밀번호 Field
					TextField("", text: $user.name)
						.modifier(TextFieldClearButton(text: $user.name))
						.placeholder(when: user.name.isEmpty) {
							Text("기존 비밀번호를 입력해주세요").foregroundColor(Color("Color3"))
						}
						.frame(height: 35)
					Divider()
					// 비밀번호 Field
					TextField("", text: $user.name)
						.modifier(TextFieldClearButton(text: $user.name))
						.placeholder(when: user.name.isEmpty) {
							Text("기존 비밀번호를 입력해주세요").foregroundColor(Color("Color3"))
						}
						.frame(height: 35)
				}
				.padding(.horizontal)
			} // VStack
			.padding()
			.background(Color("cellColor"))
			.cornerRadius(20)
		} // VStack
		.padding(.horizontal, 10)
	}
}

struct ProfileEditView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileEditView(user: .constant(User.getDummy()))
	}
}
