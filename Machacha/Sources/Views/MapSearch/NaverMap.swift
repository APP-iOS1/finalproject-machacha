//
//  NaverMap.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    var coord: (Double, Double)
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    init(_ coord: (Double, Double)) {
        self.coord = coord
    }
    
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var coord: (Double, Double)
        init(_ coord: (Double, Double)) {
            self.coord = coord
        }
        
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            print("카메라 변경 - reason: \(reason)")
        }
        
        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
            print("카메라 변경 - reason: \(reason)")
        }
    }
    
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        let locationOverlay = view.mapView.locationOverlay
        view.showLocationButton = true
        view.showCompass = true
        view.showZoomControls = true
        let cameraPosition = view.mapView.cameraPosition
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.green
        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        marker.captionRequestedWidth = 100
        marker.captionText = "테스트 캡션"
        marker.captionMinZoom = 12
        marker.captionMaxZoom = 16
        
        marker.mapView = view.mapView
        
        print("camera pos: \(cameraPosition)")
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coord = NMGLatLng(lat: coord.0, lng: coord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
}
