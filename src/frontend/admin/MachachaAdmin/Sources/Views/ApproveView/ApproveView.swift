//
//  ApproveView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ApproveView: View {
	var body: some View {
		List {
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		} // List
	}
}

struct ApproveView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			ApproveView()
				.navigationTitle("가게 승인")
		}
    }
}
