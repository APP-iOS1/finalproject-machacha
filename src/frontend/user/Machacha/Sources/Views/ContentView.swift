//
//  ContentView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import AlertToast

struct ContentView: View {
    //MARK: Property Wrapper
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    @ObservedObject var tabbarManager = TabBarManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    switch tabbarManager.curTabSelection {
                    case .home:
                        HomeView()
                        //                        DetailView(selectedStore: FoodCart.getDummy())
                    case .mapSearch:
                        MapSearchView()
                    case .register:
                        EmptyView()
                    case .magazine:
                        MagazineView()
                    case .profile:
                        ProfileView()
                    }
                }
                .padding(.bottom, tabbarManager.hight)
                .overlay {
                    if tabbarManager.showTabBar {
                        CustomTabView()
                    }// ZStack
                } // ZStack
                .edgesIgnoringSafeArea(.bottom)
                .preferredColorScheme(profileVM.isDarkMode ? .dark : .light) // PreView 용
                // toast 메세지
                .toast(isPresenting: $tabbarManager.showToast){
                    //댓글 삭제 후 화면 하단 토스트 메세지 출력
                    AlertToast(displayMode: .banner(.pop), type: .regular, title: "등록하신 가게가 심사중입니다.",style: AlertToast.AlertStyle.style(titleFont: .machachaHeadline))
                }
            } // NavigationStack
            .task {
                locationManager.checkIfLocationServicesIsEnabled()
                mapSearchViewModel.cameraPosition = locationManager.coord
            }
            .fullScreenCover(isPresented: $tabbarManager.isShowingModal) {
                RegisterMapView()
                    .environmentObject(locationManager)
            }
            .onAppear {
                tabbarManager.safeArea = geometry.safeAreaInsets
            }
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
			.previewDevice(PreviewDevice(rawValue: DeviceName.iPhone_SE_3rd_generation.rawValue))
    }
}
