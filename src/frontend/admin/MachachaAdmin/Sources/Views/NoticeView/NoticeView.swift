//
//  NoticeView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct NoticeView: View {
	//MARK: Property Wrapper
	@StateObject var noticeVM = NoticeViewModel()
	@FocusState private var focused: Bool			// TextFiled를 포커스

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("제목")) {
					TextField("", text: $noticeVM.title)
						.modifier(TextFieldClearButton(text: $noticeVM.title))
						.placeholder(when: noticeVM.title.isEmpty) {
							Text("알림 및 공지에 쓰여질 제목을 입력")
								.foregroundColor(.accentColor)
								.font(.system(size: 14))
								.disabled(true)
						}
						.background(Color("cellColor"))
						.focused($focused)
				}
				
				Section(header: Text("알림 Body")) {
					TextField("", text: $noticeVM.body)
						.modifier(TextFieldClearButton(text: $noticeVM.body))
						.placeholder(when: noticeVM.body.isEmpty) {
							Text("알림 body에 쓰여질 내용")
								.foregroundColor(.accentColor)
								.font(.system(size: 14))
								.disabled(true)
						}
						.background(Color("cellColor"))
				}
				
				Section(header: Text("내용")) {
					ZStack {
						if noticeVM.contents.isEmpty {
							TextEditor(text: .constant("알림 및 공지 내용을 입력"))
								.foregroundColor(.accentColor)
								.font(.system(size: 14))
								.disabled(true)
						}
						TextEditor(text: $noticeVM.contents)
							.opacity(noticeVM.contents.isEmpty ? 0.25 : 1)
					}
				}
			}
            .onTapGesture {
                
            }
			.background(Color("bgColor"))
			.scrollContentBackground(.hidden)
			.navigationBarBackButtonHidden()
			.navigationBarTitle(Tab.notice.title, displayMode: .inline)
			.toolbarBackground(Color.accentColor, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
                        Task {
                            noticeVM.userId = try await noticeVM.fetchUserId() // 유저 목록 불러오기
                            noticeVM.userTokens = try await noticeVM.fetchUserToken() // 유저 토큰 불러오기
                            await noticeVM.sendMessageToDevice() // send FCM
                            await noticeVM.addNotice()
                            noticeVM.initData() // Data 초기화
                            
                        }

					} label: {
						Text("전송")
					}
				} // ToolbarItem
			})
		}
	}
}

// MARK: - TextFiled에 x 버튼으로 Clear
struct TextFieldClearButton: ViewModifier {
	@Binding var text: String
	
	func body(content: Content) -> some View {
		HStack {
			content
			
			if !text.isEmpty {
				Button(
					action: { self.text = "" },
					label: {
						Image(systemName: "xmark.circle")
							.foregroundColor(Color(UIColor.opaqueSeparator))
							.padding(.vertical, 10)
					}
				)
			}
		}
	}
}

struct NoticeView_Previews: PreviewProvider {
	static var previews: some View {
		NoticeView()
	}
}
