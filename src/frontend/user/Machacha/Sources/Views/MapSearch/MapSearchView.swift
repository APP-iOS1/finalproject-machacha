//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @StateObject var mapSerachViewModel = MapSearchViewModel()
    @State var currentIndex: Int = 0
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader()
                    Spacer()
                    
                    SnapCarousel(index: $currentIndex, items: mapSerachViewModel.foodCarts) { foodCart in
                        NavigationLink {
                            EmptyView()
                        } label: {
                            MapFooterCell(foodCart: foodCart)
                        }


//                        GeometryReader { proxy in
//                            let size = proxy.size
//                            MapFooterCell(foodCart: foodCart)
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: size.width)
//                                .padding(.vertical, Screen.maxHeight - 420)
//                        }
                    }
                }
                .zIndex(1)
                
                NaverMap(coord: (mapSerachViewModel.coord.0, mapSerachViewModel.coord.1), currentIndex: $currentIndex, foodCarts:  mapSerachViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                mapSerachViewModel.checkIfLocationServicesIsEnabled()
            }
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
