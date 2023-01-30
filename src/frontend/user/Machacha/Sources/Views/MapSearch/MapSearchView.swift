//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @StateObject var mapSerachViewModel = MapSearchViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                MapHeader()
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(mapSerachViewModel.foodCarts) { foodCart in
                            MapFooterCell(foodCart: foodCart)
                        }
                    }
                }
                
            }
            .zIndex(1)
            
            NaverMap(coord: (mapSerachViewModel.coord.0, mapSerachViewModel.coord.1), foodCarts:  mapSerachViewModel.foodCarts)
                .ignoresSafeArea(.all, edges: .top)
        }
        .onAppear {
            mapSerachViewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
