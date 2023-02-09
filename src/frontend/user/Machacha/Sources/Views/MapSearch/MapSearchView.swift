//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NMapsMap

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
                    MapHeader()
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
                NaverMap(cameraPosition: $mapSearchViewModel.cameraPosition, currentIndex: $currentIndex, foodCarts: foodCartViewModel.foodCarts, userCoord: locationManager.userLocation)
                    .ignoresSafeArea(.all, edges: .top)
                    .onChange(of: mapSearchViewModel.zoomLevel) { newValue in
                        print("zoom Level : \(newValue)")
                    }
            }
            .onAppear {
                mapSearchViewModel.foodCarts = foodCartViewModel.foodCarts
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
