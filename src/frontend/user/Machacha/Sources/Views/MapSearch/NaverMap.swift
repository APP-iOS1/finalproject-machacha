//
//  NaverMap.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    @Binding var coord: (Double, Double)
    @Binding var currentIndex: Int
    var foodCarts: [FoodCart]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }

    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
//        view.showLocationButton = true
        // Foodcart를 맵에 마커로 표현
        for (index, foodCart) in foodCarts.enumerated() {
            let marker = NMFMarker()
            
			marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
            marker.iconImage = image
//
            marker.width = CGFloat(25)
            marker.height = CGFloat(25)
            marker.isHideCollidedMarkers = true

            // MARK: - Mark 터치 시 이벤트 발생
            marker.touchHandler = { (overlay) -> Bool in
                print("\(foodCart.name) marker touched")
                coord = (foodCart.geoPoint.latitude, foodCart.geoPoint.longitude)
                print("geoPoint : \(coord)")
                marker.width = CGFloat(50)
                marker.height = CGFloat(50)
                print("naverMap Index : \(currentIndex)")
                currentIndex = index
                
                
                return true
            }
            marker.mapView = view.mapView
        }
     
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.touchDelegate = context.coordinator
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
    // 카메라의 움직임이 시작할 때 호출
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
//        print("카메라 변경 - reason: \(reason)")
    }
    
    // 카메라가 움직이고 있을 때 호출
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {

    }
    
    // 카메라의 움직임이 끝났을 때 호출
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        coord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
        print("현재 카메라 좌표 : \(coord)")
    }
}

// MARK: - 지도 터치에 이용되는 Delegate
extension Coordinator: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map Tapped")
    }
}
