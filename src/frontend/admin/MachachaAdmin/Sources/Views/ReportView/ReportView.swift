//
//  ReportView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ReportView: View {
	var body: some View {
		NavigationView {
			List {
				Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
			} // List
			.background(Color("bgColor"))
			.scrollContentBackground(.hidden)
			.navigationBarBackButtonHidden()
			.navigationBarTitle(Tab.report.title, displayMode: .inline)
			.toolbarBackground(Color.accentColor, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			.toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						
					} label: {
						Text("제거")
					}
				} // ToolbarItem
			})
		}
		
	}
}

struct ReportView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ReportView()
				.navigationTitle("신고 누적 가게")
		}
	}
}
