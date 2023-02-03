//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @StateObject var mapSerachViewModel = MapSearchViewModel()
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @State var coordinate: (Double, Double) = (37.566249, 126.992227)
    @State var currentIndex: Int = 0
    @State var isTap: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader()
                    Spacer()
                    
                    
                    SnapCarousel(index: $currentIndex, items: foodCartViewModel.foodCarts, coord: $mapSerachViewModel.coord) { foodCart in
                        MapFooterCell(foodCart: foodCart, isFocus: false)
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, Screen.maxHeight - 400)
                            .onTapGesture {
                                self.isTap = true
                            }
                        
                        
//                        GeometryReader { proxy in
//                            let size = proxy.size
//                            MapFooterCell(foodCart: foodCart)
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: size.width)
//                                .padding(.vertical, Screen.maxHeight - 420)
//                                .onTapGesture {
//                                    self.isTap = true
//                                }
//                        }
                    }
                    
                }
                .navigationDestination(isPresented: $isTap) {
                    DetailView(selectedStore: foodCartViewModel.foodCarts[currentIndex])
                }
                .zIndex(1)
                NaverMap(coord: $mapSerachViewModel.coord, currentIndex: $currentIndex, foodCarts: foodCartViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                mapSerachViewModel.checkIfLocationServicesIsEnabled()
                coordinate = mapSerachViewModel.coord
            }
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(FoodCartViewModel())
    }
}
