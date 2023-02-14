//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NMapsMap
// Marker 생성 오류
// onAppear 시점에서 값이 할당되지 않아 마커를 그리지 못함
// makeUIView는 한번만 호출됨
// updateUIView는 binding 값이 변경될 때 호출됨
// SwiftUI -> UIKit으로 바인딩 과정에서 marker가 렌더링 되지 않음
// Binding FoodCart를 할당해서 렌더링 불가 -> Binding는 get-only~~~
// MakeUI뷰는 한번만 호출이 되는데 첫번째 렌더링 될때 값을 가져오지 못함(비동기아님!!)
// 해결 방법
// 1. updateUIView에서 계속 그려준다 -> 굉장히 위험함, 터질거 같음
// 2. 강제로 맵을 1.5~2.0 정도 dispatchqueue로 멈추고 그려준다(강제로 데이터 기다려주기)
// 3. delegate를 만든다?
// 4. Binding으로 넘겨주는 방법밖에 없는거 같음 -> tag를 누를때마다 실시간으로 마커를 다시 그려줘야함
// 최후의 수단
// 맵을 여러개 그려서 바꿔치기 한다
struct MapSearchView: View {
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    @State var cameraCoord: LatLng = (37.566249, 126.992227)
    //    @State var currentIndex: Int = Coordinator.shared.currentIndex
    @State var isTap: Bool = false
    @State var fromToSearchView = false
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader(currentIndex: $coordinator.currentIndex, cameraPosition: $mapSearchViewModel.cameraPosition, fromSearchView: $fromToSearchView)
                    Spacer()
                    
                    Button {
                        print("현재 위치 조회")
                        Coordinator.shared.userLocation = mapSearchViewModel.userLocation
                        Coordinator.shared.fetchUserLocation()
                    } label: {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30)
                                    .shadow(radius: 10)
                                Image(systemName: "scope")
                                    .foregroundColor(Color("Color3"))
                            }
                        }.padding()
                        
                    }
                    
                    
                    SnapCarousel(index: $coordinator.currentIndex, foodCarts: mapSearchViewModel.foodCarts, coord: $mapSearchViewModel.cameraPosition) { foodCart in
                        MapFooterCell(foodCart: foodCart, isFocus: false)
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, Screen.maxHeight - 460)
                            .onTapGesture {
                                self.isTap = true
                            }
                    }
                    
                }
                .navigationDestination(isPresented: $isTap) {
                    
                        DetailView(selectedStore: foodCartViewModel.foodCarts[coordinator.currentIndex])
                    
                    
                }
                .zIndex(1)
                NaverMap(cameraPosition: $mapSearchViewModel.cameraPosition, currentIndex: $coordinator.currentIndex)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                if !fromToSearchView {
                    mapSearchViewModel.foodCarts = foodCartViewModel.foodCarts
                    Coordinator.shared.foodCarts = mapSearchViewModel.foodCarts
                    Coordinator.shared.setupMarkers()
                } else {
                    fromToSearchView.toggle()
                }
                print("🍎🍎🍎🍎 Map searchView onappear")
            }
            
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(LocationManager())
            .environmentObject(MapSearchViewModel())
            .environmentObject(FoodCartViewModel())
    }
}
