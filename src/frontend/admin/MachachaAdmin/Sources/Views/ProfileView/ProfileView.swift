//
//  ProfileView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
		List {
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		} // List
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			ProfileView()
				.navigationTitle("프로필")
		}
    }
}
