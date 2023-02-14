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
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    
    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> NMFNaverMapView {  // some 빼줌
        context.coordinator.getNaverMapView()
        
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {

        if !Coordinator.shared.markers.isEmpty {
            let lat = Coordinator.shared.markers[currentIndex].position.lat
            let lng = Coordinator.shared.markers[currentIndex].position.lng

            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 0.3
            Coordinator.shared.mapView.mapView.moveCamera(cameraUpdate)
        }

        print("updateUIView")
        
    }
    // MARK: - makeCoordinator
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
}

// MARK: - Coordinator
final class Coordinator: NSObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate, ObservableObject {
    static let shared = Coordinator()
    
    let mapView = NMFNaverMapView(frame: .zero)
    var foodCarts: [FoodCart] = []
    var markers: [NMFMarker] = []
    // 사용자의 현재 위치(locationManager)
    var userLocation: LatLng?
    
    var locationManager: CLLocationManager?
    @Published var currentIndex = 0
    
    private let polygonPoints = [
        NMGLatLng(lat: 37.72468, lng: 125.87630),
        NMGLatLng(lat: 38.77778, lng: 129.60256),
        NMGLatLng(lat: 34.84530, lng: 130.30152),
        NMGLatLng(lat: 34.10799, lng: 125.58587),
        NMGLatLng(lat: 37.72468, lng: 125.87630)
    ]
    
    private let servicePoints = [
        NMGLatLng(lat: 37.57009, lng: 126.97567),
        NMGLatLng(lat: 37.56908, lng: 126.97608),
        NMGLatLng(lat: 37.56850, lng: 126.97699),
        NMGLatLng(lat: 37.56504, lng: 126.97728),
        NMGLatLng(lat: 37.56492, lng: 126.97851),
        NMGLatLng(lat: 37.56601, lng: 126.97929),
        NMGLatLng(lat: 37.56593, lng: 126.98237),
        NMGLatLng(lat: 37.56205, lng: 126.98126),
        NMGLatLng(lat: 37.55781, lng: 126.98317),
        NMGLatLng(lat: 37.55626, lng: 126.98331),
        NMGLatLng(lat: 37.55673, lng: 126.98585),
        NMGLatLng(lat: 37.55797, lng: 126.98708),
        NMGLatLng(lat: 37.55909, lng: 126.98746),
        NMGLatLng(lat: 37.56042, lng: 126.98852),
        NMGLatLng(lat: 37.56100, lng: 126.98773),
        NMGLatLng(lat: 37.56119, lng: 126.99066),
        NMGLatLng(lat: 37.56279, lng: 126.99029),
        NMGLatLng(lat: 37.56266, lng: 126.98900),
        NMGLatLng(lat: 37.56435, lng: 126.98795),
        NMGLatLng(lat: 37.56526, lng: 126.98782),
        NMGLatLng(lat: 37.56536, lng: 126.98886),
        NMGLatLng(lat: 37.56577, lng: 126.98921),
        NMGLatLng(lat: 37.56588, lng: 126.98979),
        NMGLatLng(lat: 37.56679, lng: 126.98970),
        NMGLatLng(lat: 37.56685, lng: 126.99083),
        NMGLatLng(lat: 37.56808, lng: 126.99086),
        NMGLatLng(lat: 37.56874, lng: 126.98275),
        NMGLatLng(lat: 37.56910, lng: 126.97747),
        NMGLatLng(lat: 37.57009, lng: 126.97567)

    ]
    private override init() {
        super.init()
        
        mapView.mapView.addCameraDelegate(delegate: self)
        mapView.mapView.touchDelegate = self
        mapView.mapView.isNightModeEnabled = true
        mapView.showZoomControls = false
        mapView.mapView.positionMode = .normal
        mapView.mapView.minZoomLevel = 14
        
        if let userLocation = userLocation {
            print("🍎🍎🍎🍎 get User Location!!!")
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: userLocation.0, lng: userLocation.1))
            mapView.mapView.moveCamera(cameraUpdate)
        }
        
        
        // 서비스 지역 표시를 위한 폴리곤
        let polygon = NMGPolygon(ring: NMGLineString(points: polygonPoints), interiorRings: [NMGLineString(points: servicePoints)])
        let polygonOverlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)
        polygonOverlay?.fillColor = UIColor(named: "ServiceArea") ?? .blue
        
        let polyLine = NMGLineString(points: servicePoints)
        let polyLineOverlay = NMFPolylineOverlay(polyLine as! NMGLineString<AnyObject>)
        polyLineOverlay?.width = 3
        polyLineOverlay?.color = UIColor(named: "Color2") ?? .blue
        
        polygonOverlay?.mapView = mapView.mapView
        polyLineOverlay?.mapView = mapView.mapView
        
        checkIfLocationServicesIsEnabled()
    }
    
    deinit {
        print("🍎🍎🍎🍎Coordinator deinit!")
    }
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
                
            } else {
                print("Show an alert letting them know this is off and to go turn i on.")
            }
        }
        
        
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into setting to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        mapView
    }
    
    func setupMarkers() {
        for foodCart in foodCarts {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage(named: "store2")!)
            marker.iconImage = image
            
            marker.width = CGFloat(50)
            marker.height = CGFloat(50)
            markers.append(marker)
        }
        
        for marker in markers {
            marker.mapView = mapView.mapView
        }
        markerTapped()
    }
    
    func removeMarkers() {
        while !markers.isEmpty {
            let removeMarker = markers.removeFirst()
            removeMarker.mapView = nil
        }
    }
    
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            print("🍎🍎🍎🍎 get User Location!!!")
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0))
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 0.3
            mapView.mapView.moveCamera(cameraUpdate)
        }
    }
    
    func markerTapped() {
        for (index, marker) in markers.enumerated() {
            // MARK: - Mark 터치 시 이벤트 발생
            marker.touchHandler = { (overlay) -> Bool in
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 0.3
                self.mapView.mapView.moveCamera(cameraUpdate)
                
                // marker의 인덱스와 footerCell의 Index 동기화
                self.currentIndex = index
                //                cameraPosition = (marker.position.lat, marker.position.lng)
                //                print("geoPoint : \(cameraPosition)")
                //
                //                print("naverMap Index : \(currentIndex)")
                //                currentIndex = index
                return true
            }
            marker.mapView = mapView.mapView
        }
    }
    
    func cellScrolled() {
        print("🍎🍎🍎🍎 currentIndex : \(currentIndex)")
        let lat = markers[currentIndex].position.lat
        let lng = markers[currentIndex].position.lng
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.3
        print("🍎🍎🍎🍎 cell Scrolled")
    }
}
