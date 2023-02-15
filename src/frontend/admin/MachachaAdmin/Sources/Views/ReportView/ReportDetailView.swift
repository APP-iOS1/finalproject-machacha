//
//  ReportDetailView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/14.
//

import SwiftUI

struct ReportDetailView: View {
	var commentReportList = ["불법정보가 포함 되어있어요.", "영리 목적 정보가 포함 되어있어요.","같은 내용이 도배 되어있어요.", "선정적인 단어가 포함 되어있어요", "욕설/인신공격이 포함되어있어요.", "기타 정보가 있어요."]
	var storeReportList = ["문 닫은 포장마차에요.", "포장마차 주소가 틀려요.", "위치표시가 틀려요.", "휴무일 정보가 틀려요.", "메뉴 정보가 틀려요.", "기타 정보가 있어요."]
//	@State private var checkArr = Array(Array(repeating: false, count: 6))
	@State private var text = ""
	@FocusState private var isInFocusText: Bool
	@StateObject var reportVM: ReportViewModel
	@Environment(\.colorScheme) var colorScheme // 다크모드일 때 색 설정 변경을 위해 선언
	@Environment(\.dismiss) var dismiss
	let report: Report
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					VStack(alignment: .leading, spacing: 7) {
						if report.type == 0 { //가게 정보 신고
							ForEach(storeReportList.indices, id: \.self) { idx in
								HStack {
									Text(storeReportList[idx])
									Spacer()
									Image(systemName: report.content[idx] ? "checkmark.circle.fill" : "circle")
										.foregroundColor(.accentColor)
										.font(.system(size: 20))
								}
								Divider()
									.padding(.vertical, 5)
							} //ForEach
						} else if report.type  == 1 { //댓글 신고
							ForEach(commentReportList.indices, id: \.self) { idx in
								HStack {
									Text(commentReportList[idx])
									Spacer()
									Image(systemName: report.content[idx] ? "checkmark.circle.fill" : "circle")
										.foregroundColor(.accentColor)
										.font(.system(size: 20))
								}
								Divider()
									.padding(.vertical, 5)
							}
						}
												
						Spacer()
						
					}//VStack
					.padding(.horizontal, 30)
					.padding(.top, 30)
					VStack {
						Text(report.etc)
							.frame(width: Screen.maxWidth - 100, height: 150)
							.padding(30)
							.background(Color("bgColor"))
							.cornerRadius(8)
					}
					Text("")
				}
				.background(Color("cellColor"))
			} //VStack
			.onTapGesture { // 키보드가 올라왔을 때 다른 화면 터치 시 키보드가 내려감
//				self.endTextEditing()
			}
			.background(Color("bgColor"))
			.scrollContentBackground(.hidden)
			.navigationBarBackButtonHidden()
			.navigationBarTitle("신고내역", displayMode: .inline)
			.toolbarBackground(Color.accentColor, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "chevron.backward")
							.font(.system(size: 17))
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						
					} label: {
						Text("제거")
					}
				} // ToolbarItem

			}
		} //NavigationStack
	}
}

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
		ReportDetailView(reportVM: ReportViewModel(), report: Report.getDummy())
    }
}
