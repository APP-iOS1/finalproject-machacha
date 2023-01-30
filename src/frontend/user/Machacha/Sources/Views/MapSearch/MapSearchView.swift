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
                Button {
                    mapSerachViewModel.coord = (37.566249, 126.992227)
                } label: {
                    Text("을지로3가역")
                }
                
                Spacer()
            }
            .zIndex(1)
            
            NaverMap((mapSerachViewModel.coord.0, mapSerachViewModel.coord.1), foodCarts:  mapSerachViewModel.foodCarts)
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
