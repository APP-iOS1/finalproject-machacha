//
//  NaverMap.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    @State var coord: (Double, Double)
    var foodCarts: [FoodCart]
    @Binding var isPresent: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }

    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.showLocationButton = true

        let cameraPosition = view.mapView.cameraPosition
        
        // Foodcart를 맵에 마커로 표현
        for foodCart in foodCarts {
            let marker = NMFMarker()
            
			marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
            marker.iconImage = image
//
            marker.width = CGFloat(25)
            marker.height = CGFloat(25)

            
            // MARK: - Mark 터치 시 이벤트 발생
            marker.touchHandler = { (overlay) -> Bool in
                print("\(foodCart.name) marker touched")
                coord = (foodCart.geoPoint.latitude, foodCart.geoPoint.longitude)
                marker.width = CGFloat(50)
                marker.height = CGFloat(50)
                isPresent.toggle()
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
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.3
        uiView.mapView.moveCamera(cameraUpdate)
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
//        coord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
        coord = (37.566249, 126.992227)
        print(coord)
    }
}
