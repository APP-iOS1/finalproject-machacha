//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NMapsMap

struct MapSearchView: View {
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
                        mapSearchViewModel.cameraPosition = locationManager.coord
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

                    
                    SnapCarousel(index: $currentIndex, items: mapSearchViewModel.foodCarts, coord: $mapSearchViewModel.cameraPosition) { foodCart in
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
//                    DetailView(selectedStore: mapSearchViewModel.foodCarts[currentIndex])
                }
                .zIndex(1)
                NaverMap(cameraPosition: $mapSearchViewModel.cameraPosition, currentIndex: $currentIndex, foodCarts: mapSearchViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: .top)
                    .onChange(of: mapSearchViewModel.cameraPosition.0) { newValue in
                        print("onchange \(newValue)")
                    }
                    .onChange(of: mapSearchViewModel.zoomLevel) { newValue in
                        print("zoom : \(newValue)")
                    }
            }
            .onAppear {
                mapSearchViewModel.fetchFoodCarts()
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
