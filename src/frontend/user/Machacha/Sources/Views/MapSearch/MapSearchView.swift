//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    @State var cameraCoord: (Double, Double) = (37.566249, 126.992227)
    @State var currentIndex: Int = 0
    @State var isTap: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader()
                    Spacer()
                    
                    
                    SnapCarousel(index: $currentIndex, items: mapSearchViewModel.foodCarts, coord: $cameraCoord) { foodCart in
                        MapFooterCell(foodCart: foodCart, isFocus: false)
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, Screen.maxHeight - 400)
                            .onTapGesture {
                                self.isTap = true
                            }
                    }
                    
                }
                .navigationDestination(isPresented: $isTap) {
//                    DetailView(name: mapSearchViewModel.foodCarts[currentIndex].name)
                    DetailView(selectedStore: mapSearchViewModel.foodCarts[currentIndex])
                }
                .zIndex(1)
                NaverMap(coord: $cameraCoord, currentIndex: $currentIndex, foodCarts: mapSearchViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                cameraCoord = locationManager.coord
            }
        }
    }
//    @ViewBuilder private func DetailView(name: String) -> some View {
//        VStack {
//            Text("가게 이름 : \(name)")
//        }
//    }
    
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(LocationManager())
            .environmentObject(MapSearchViewModel())
    }
}
