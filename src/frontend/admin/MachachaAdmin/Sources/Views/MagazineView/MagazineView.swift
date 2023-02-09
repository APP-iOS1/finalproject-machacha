//
//  MagazineView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct MagazineView: View {
    var body: some View {
		List {
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		} // List
    }
}

struct MagazineView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			MagazineView()
				.navigationTitle("매거진 작성")
		}
    }
}
