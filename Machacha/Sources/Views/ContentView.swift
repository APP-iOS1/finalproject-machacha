//
//  ContentView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
	//MARK: Property Wrapper
	@ObservedObject var tabbarManager = TabBarManager.shared

    var body: some View {
		NavigationView {
			ZStack {
				ZStack {
					switch tabbarManager.curTabSelection {
					case .home:
                        SplashView()
						//HomeView()
					case .mapSearch:
						MapSearchView()
					case .register:
						RegisterView()
					case .magazine:
						MagazineView()
					case .profile:
						ProfileView()
					}
				} // ZStack
				.padding(.bottom, tabbarManager.bottomPadding)
				
				if (tabbarManager.showTabBar) {
					CustomTabView()
				}
			} // ZStack
			.edgesIgnoringSafeArea(.bottom)
		} // NavigationStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
