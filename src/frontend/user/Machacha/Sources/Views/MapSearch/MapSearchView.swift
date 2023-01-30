//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @StateObject var mapSerachViewModel = MapSearchViewModel()
    @State var showingSheet = false
    
    var body: some View {
        ZStack {
            VStack {
                MapHeader()
                Spacer()
            }
            .zIndex(1)
            
            NaverMap(coord: (mapSerachViewModel.coord.0, mapSerachViewModel.coord.1), foodCarts:  mapSerachViewModel.foodCarts, isPresent: $showingSheet)
                .ignoresSafeArea(.all, edges: .top)
        }
        .sheet(isPresented: $showingSheet, content: {
            EmptyView()
                .presentationDetents([.fraction(0.2), .fraction(1.0)])
        })
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
