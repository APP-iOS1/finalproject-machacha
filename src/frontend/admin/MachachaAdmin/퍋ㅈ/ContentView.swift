//
//  ContentView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/08.
//

import SwiftUI

struct ContentView: View {
	//MARK: Property Wrapper
	@State private var selection = 0

	//MARK: Property
	
    var body: some View {
		TabView(selection: $selection) {
			Text("첫번째 뷰")
				.font(.system(size: 30))
				.tabItem {
					Image(systemName: "house.fill")
					Text("승인")
				}.tag(0)
			
			Text("두번째 뷰")
				.font(.system(size: 30))
				.tabItem {
					Image(systemName: "bookmark.circle.fill")
					Text("북마크")
				}.tag(1)
			
			Text("세번째 뷰")
				.font(.system(size: 30))
				.tabItem {
					Image(systemName: "video.circle.fill")
					Text("비디오")
				}.tag(2)
		} // TabView
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
