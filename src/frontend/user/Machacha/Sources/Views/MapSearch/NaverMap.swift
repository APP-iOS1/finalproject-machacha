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
    
    private let polygonPoints = [
        NMGLatLng(lat: 37.72468, lng: 125.87630),
        NMGLatLng(lat: 38.77778, lng: 129.60256),
        NMGLatLng(lat: 34.84530, lng: 130.30152),
        NMGLatLng(lat: 34.10799, lng: 125.58587),
        NMGLatLng(lat: 37.72468, lng: 125.87630)
    ]
    
    private let servicePoints = [
        NMGLatLng(lat: 37.56601, lng: 126.98355),
        NMGLatLng(lat: 37.56596, lng: 126.98406),
        NMGLatLng(lat: 37.56513, lng: 126.98450),
        NMGLatLng(lat: 37.56485, lng: 126.98476),
        NMGLatLng(lat: 37.56393, lng: 126.98511),
        NMGLatLng(lat: 37.56403, lng: 126.98599),
        NMGLatLng(lat: 37.56178, lng: 126.98668),
        NMGLatLng(lat: 37.56103, lng: 126.98673),
        NMGLatLng(lat: 37.56071, lng: 126.98341),
        NMGLatLng(lat: 37.56133, lng: 126.98315),
        NMGLatLng(lat: 37.56339, lng: 126.98233),
        NMGLatLng(lat: 37.56351, lng: 126.98218),
        NMGLatLng(lat: 37.56547, lng: 126.98270),
        NMGLatLng(lat: 37.56602, lng: 126.98357),
        NMGLatLng(lat: 37.56601, lng: 126.98355)
    ]
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
        
            self.markers.append(marker)
        }
    }
    
    
    
    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .normal
        view.mapView.minZoomLevel = 16
        view.mapView.zoomLevel = mapSearchViewModel.zoomLevel

        print("cameraPosition : \(cameraPosition)")
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: cameraPosition.0, lng: cameraPosition.1))
        view.mapView.moveCamera(cameraUpdate)
        
        // 서비스 지역 표시를 위한 폴리곤
        let polygon = NMGPolygon(ring: NMGLineString(points: polygonPoints), interiorRings: [NMGLineString(points: servicePoints)])
        let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
        polygonOverlay?.fillColor = UIColor(named: "ServiceArea") ?? .blue
        
        let polyLine = NMGLineString(points: servicePoints)
        let polyLineOverlay = NMFPolylineOverlay(polyLine as! NMGLineString<AnyObject>)
        polyLineOverlay?.width = 3
        polyLineOverlay?.color = UIColor(named: "Color2") ?? .blue
        
        polygonOverlay?.mapView = view.mapView
        polyLineOverlay?.mapView = view.mapView
        
        
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
    class Coordinator: NSObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
        @Binding var cameraPosition: LatLng
        @Binding var zoomLevel: Double
        
        init(_ cameraPosition: Binding<(LatLng)>, _ zoomLevel: Binding<Double>) {
            _cameraPosition = cameraPosition
            _zoomLevel = zoomLevel
        }
        // MARK: - 카메라 이동이 끝났음을 알려주는 이벤트
        func mapViewCameraIdle(_ mapView: NMFMapView) {
            cameraPosition = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
            zoomLevel = mapView.cameraPosition.zoom
        }
        // MARK: - 맵 터치 이벤트
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("Map Tapped")
        }
    }
    
}
