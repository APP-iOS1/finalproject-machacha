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
    @State var currentIndex: Int = 0
    @State var isTap: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader(currentIndex: $currentIndex, cameraPosition: $mapSearchViewModel.cameraPosition)
                    Spacer()
                    
                    Button {
                        print("현재 위치 조회")
                        mapSearchViewModel.cameraPosition = mapSearchViewModel.userLocation
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
                    
                    
                    SnapCarousel(index: $currentIndex, foodCarts: mapSearchViewModel.foodCarts, coord: $mapSearchViewModel.cameraPosition) { foodCart in
                        MapFooterCell(foodCart: foodCart, isFocus: false)
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, Screen.maxHeight - 460)
                            .onTapGesture {
                                self.isTap = true
                            }
                    }
                    
                }
                .navigationDestination(isPresented: $isTap) {
                    //                    TestView(name: mapSearchViewModel.foodCarts[currentIndex].name)
                    //                    if !mapSearchViewModel.foodCarts.isEmpty {
                    //                        DetailView(selectedStore: mapSearchViewModel.foodCarts[currentIndex])
                    //                    }
                    
                }
                .zIndex(1)
                NaverMap(cameraPosition: $mapSearchViewModel.cameraPosition, currentIndex: $currentIndex, foodCarts: mapSearchViewModel.foodCarts, userCoord: locationManager.userLocation)
                    .ignoresSafeArea(.all, edges: .top)
                    .onChange(of: mapSearchViewModel.zoomLevel) { newValue in
                        print("zoom Level : \(newValue)")
                    }
            }
            .onAppear {
                mapSearchViewModel.foodCarts = foodCartViewModel.foodCarts

                print("onappear")
                print("\(mapSearchViewModel.foodCarts.count)")
            }
            
        }
    }
    @ViewBuilder private func TestView(name: String) -> some View {
        VStack {
            Text("가게 이름 : \(name)")
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(LocationManager())
            .environmentObject(MapSearchViewModel())
    }
}
