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
    @State var foodCarts: [FoodCart]
    @State var userCoord: LatLng
    @State private var markers: [NMFMarker] = []
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    
    init(cameraPosition: Binding<LatLng>, currentIndex: Binding<Int>, foodCarts: [FoodCart], userCoord: LatLng) {
        self._cameraPosition = cameraPosition
        self._currentIndex = currentIndex
        self.foodCarts = foodCarts
        self.userCoord = userCoord
        
        for foodCart in foodCarts {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage(named: "store2")!)
            marker.iconImage = image
            
            marker.width = CGFloat(50)
            marker.height = CGFloat(50)
            
            self.markers.append(marker)
        }
    }
    
    
    
    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> NMFNaverMapView {  // some 빼줌
        //        context.coordinator.userLocation = userCoord
        //        context.coordinator.markers = self.markers
        return context.coordinator.getNaverMapView()
        
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
            //            print("currentindex : \(currentIndex)")
            // 이부분에서 Marker가 커지는 작업을 처리해줘야함 -> 마커 생성을 밖에서 해줘야할 거 같음
            for (index, marker) in markers.enumerated() {
                print("index\(markers[index])")
                markers[index].width = currentIndex == index ? CGFloat(70) : CGFloat(35)
                markers[index].height = currentIndex == index ? CGFloat(70) : CGFloat(35)
                //                marker.mapView = uiView.mapView // 필요없을듯
                
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
}

final class Coordinator: NSObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    static let shared = Coordinator()
    
    private let mapView = NMFNaverMapView(frame: .zero)
    var foodCarts: [FoodCart] = []
    var markers: [NMFMarker] = []
    // 사용자의 현재 위치(locationManager)
    var userLocation: LatLng?
    
    var locationManager: CLLocationManager?

    
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
    
    private override init() {
        super.init()
        
        mapView.mapView.addCameraDelegate(delegate: self)
        mapView.mapView.touchDelegate = self
        
        mapView.showZoomControls = false
        mapView.mapView.positionMode = .normal
        mapView.mapView.minZoomLevel = 15
        
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
        
        
        
        print("🍎🍎🍎🍎foodCart \(foodCarts.count)")
        // 루프 안돔
        //            for (index, marker) in markers.enumerated() {
        //                // MARK: - Mark 터치 시 이벤트 발생
        //                marker.touchHandler = { (overlay) -> Bool in
        //                    cameraPosition = (marker.position.lat, marker.position.lng)
        //                    print("geoPoint : \(cameraPosition)")
        //
        //                    print("naverMap Index : \(currentIndex)")
        //                    currentIndex = index
        //                    return true
        //                }
        //                marker.mapView = mapView.mapView
        //            }
        
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
    
    func makeMarkers() {
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
            mapView.mapView.moveCamera(cameraUpdate)
        }
    }
}
