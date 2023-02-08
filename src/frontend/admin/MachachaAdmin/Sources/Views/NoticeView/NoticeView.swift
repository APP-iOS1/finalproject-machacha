//
//  NoticeView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct NoticeView: View {
    var body: some View {
		List {
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		}
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			NoticeView()
				.navigationTitle("전체 알림")
		}
    }
}
