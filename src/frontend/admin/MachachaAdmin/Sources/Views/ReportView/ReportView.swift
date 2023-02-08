//
//  ReportView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
		List {
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		} // List
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
