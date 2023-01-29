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
    var foodCarts: [FoodCart]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    init(_ coord: (Double, Double), foodCarts: [FoodCart]) {
        self.coord = coord
        self.foodCarts = foodCarts
    }
    

    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.showLocationButton = true
        view.showCompass = true
        view.showZoomControls = true
        let cameraPosition = view.mapView.cameraPosition
        
        // Foodcart를 맵에 마커로 표현
        for foodCart in foodCarts {
            let marker = NMFMarker()
            
			marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            
            let image = NMFOverlayImage(name: foodCart.markerImage)
            
//            marker.iconImage = image
//
//            marker.width = CGFloat(Screen.maxWidth/10)
//            marker.height = CGFloat(Screen.maxHeight/10)
            
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
            marker.iconTintColor = UIColor.green
            marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
            marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
            
            // MARK: - Mark 터치 시 이벤트 발생
            marker.touchHandler = { (overlay) -> Bool in
                print("marker touched")
                
                return true
            }
            marker.mapView = view.mapView
        }
     
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coord = NMGLatLng(lat: coord.0, lng: coord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
    func setupMarker() {
        
    }
}

class Coordinator: NSObject {
    var coord: (Double, Double)
    init(_ coord: (Double, Double)) {
        self.coord = coord
    }
}

// MARK: - 카메라 이동시 발생하는 Delegate
extension Coordinator: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//        print("카메라 변경 - reason: \(reason)")
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//        print("카메라 변경 - reason: \(reason)")
    }
}
