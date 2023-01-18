//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NMapsMap

struct MapSearchView: View {
    @State var coord: (Double, Double) = (126.986418, 37.560840)
    @StateObject var mapSerachViewModel = MapSearchViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {coord = (126.992227, 37.566249)}) {
                    Text("을지로3가역")
                }
                Button(action: {coord = (126.986418, 37.560840)}) {
                    Text("명동역")
                }
                Spacer()
            }
            .zIndex(1)
            
            UIMapView(coord: coord)
                .edgesIgnoringSafeArea(.vertical)
        }
        .onAppear {
            mapSerachViewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct UIMapView: UIViewRepresentable {
    var coord: (Double, Double)
  
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)}
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
