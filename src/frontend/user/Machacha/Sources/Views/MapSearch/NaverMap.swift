//
//  NaverMap.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import SwiftUI
import NMapsMap

typealias LatLng = (Double, Double)

struct NaverMap: UIViewRepresentable {
    @Binding var cameraPosition: LatLng
    @Binding var currentIndex: Int
    var foodCarts: [FoodCart]
    var markers: [NMFMarker] = []
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator($cameraPosition, $mapSearchViewModel.zoomLevel)
    }
    
    init(cameraPosition: Binding<LatLng>, currentIndex: Binding<Int>, foodCarts: [FoodCart]) {
        self._cameraPosition = cameraPosition
        self._currentIndex = currentIndex
        self.foodCarts = foodCarts
        
        for (index, foodCart) in foodCarts.enumerated() {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
            marker.iconImage = image
            
            marker.width = CGFloat(50)
            marker.height = CGFloat(50)
            marker.isHideCollidedMarkers = true
            
            
            self.markers.append(marker)
        }
    }
    
    
    
    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        // zoom Level 유지
        view.mapView.zoomLevel = mapSearchViewModel.zoomLevel
        view.showLocationButton = true
        for (index, marker) in markers.enumerated() {
            // MARK: - Mark 터치 시 이벤트 발생
            marker.touchHandler = { (overlay) -> Bool in
                cameraPosition = (marker.position.lat, marker.position.lng)
                print("geoPoint : \(cameraPosition)")

                print("naverMap Index : \(currentIndex)")
                currentIndex = index
                return true
            }
        
            marker.mapView = view.mapView
        }
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.touchDelegate = context.coordinator
        print("markers : \(markers.count)")
        return view
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        let point = (round(uiView.mapView.cameraPosition.target.lat*100000)/100000.0,
                     round(uiView.mapView.cameraPosition.target.lng*100000)/100000.0)
        if (round(cameraPosition.0*100000)/100000.0, round(cameraPosition.1*100000)/100000.0) != point {
            let coord = NMGLatLng(lat: cameraPosition.0, lng: cameraPosition.1)
            let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 0.3
            uiView.mapView.moveCamera(cameraUpdate)
    //        mapSearchViewModel.zoomLevel = uiView.mapView.zoomLevel
            print("currentindex : \(currentIndex)")
            // 이부분에서 Marker가 커지는 작업을 처리해줘야함 -> 마커 생성을 밖에서 해줘야할 거 같음
            for (index, marker) in markers.enumerated() {
                print("index\(markers[index])")
                markers[index].width = currentIndex == index ? CGFloat(70) : CGFloat(35)
                markers[index].height = currentIndex == index ? CGFloat(70) : CGFloat(35)
                marker.mapView = uiView.mapView

                marker.touchHandler = { (overlay) -> Bool in
    //                print("\(foodCart.name) marker touched")
                    self.cameraPosition = (marker.position.lat, marker.position.lng)
                    
                    print("naverMap Index : \(currentIndex)")
                    currentIndex = index
                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: cameraPosition.0, lng: cameraPosition.1))
                    uiView.mapView.moveCamera(cameraUpdate)
                    return true
                }
            }
        
            print("updateUIView")
        }
    
    }
}

class Coordinator: NSObject {
    @Binding var cameraPosition: LatLng
    @Binding var zoomLevel: Double
    
    init(_ cameraPosition: Binding<(LatLng)>, _ zoomLevel: Binding<Double>) {
        _cameraPosition = cameraPosition
        _zoomLevel = zoomLevel
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

    }
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        cameraPosition = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
        zoomLevel = mapView.cameraPosition.zoom
    }
}

// MARK: - 지도 터치에 이용되는 Delegate
extension Coordinator: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map Tapped")
    }
}
