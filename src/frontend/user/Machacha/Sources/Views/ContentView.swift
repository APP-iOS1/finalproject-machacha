//
//  ContentView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
	//MARK: Property Wrapper
	@EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
	@ObservedObject var tabbarManager = TabBarManager.shared

    var body: some View {
		NavigationStack {
			ZStack {
				ZStack {
					switch tabbarManager.curTabSelection {
					case .home:
                        DetailView(selectedStore: FoodCart.getDummy())
						//HomeView()
					case .mapSearch:
						MapSearchView()
					case .register:
						EmptyView()
					case .magazine:
                        MagazineView()
					case .profile:
						ProfileView()
					}
				} // ZStack
				.padding(.bottom, tabbarManager.bottomPadding)
				.overlay {
					if tabbarManager.showTabBar {
						CustomTabView()
					}
				}
			} // ZStack
			.edgesIgnoringSafeArea(.bottom)
			.preferredColorScheme(profileVM.isDarkMode ? .dark : .light) // PreView 용
		} // NavigationStack
        .task {
            locationManager.checkIfLocationServicesIsEnabled()
            mapSearchViewModel.cameraPosition = locationManager.coord
        }
        .fullScreenCover(isPresented: $tabbarManager.isShowingModal) {
            RegisterMapView()
                .environmentObject(locationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(FoodCartViewModel())
			.environmentObject(ReviewViewModel())
			.environmentObject(ProfileViewModel())
            .environmentObject(MapSearchViewModel())
            .environmentObject(LocationManager())
    }
}
