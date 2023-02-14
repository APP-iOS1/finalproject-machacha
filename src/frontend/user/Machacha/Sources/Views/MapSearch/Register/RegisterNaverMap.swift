


import SwiftUI
import NMapsMap

struct RegisterNaverMap: UIViewRepresentable {
    @Binding var cameraCoord : (Double,Double)
    var userCoord : (Double,Double)
    
    var foodCarts: [FoodCart]
    var markers: [NMFMarker] = []
    
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
    
    func makeCoordinator() -> NMCoordinator {
        NMCoordinator($cameraCoord)
    }
    
    init(cameraCoord: Binding<(Double,Double)>,userCoord : (Double,Double),foodCarts: [FoodCart]) {
        self.foodCarts = foodCarts
        self._cameraCoord = cameraCoord
        self.userCoord = userCoord
    }

    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.showLocationButton = true
        
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.touchDelegate = (context.coordinator)
        let cameraCoord = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraCoord)
        view.mapView.moveCamera(cameraUpdate)
        
        for ( _ , foodCart) in foodCarts.enumerated() {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
            marker.iconImage = image
            
            marker.width = CGFloat(50)
            marker.height = CGFloat(50)
            marker.mapView = view.mapView
        }
        print("마커 갯수: \(markers.count)")
        
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
        
        return view
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coord = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.3
        uiView.mapView.moveCamera(cameraUpdate)
        print("update: \(coord)")
    }
    
    class NMCoordinator: NSObject ,NMFMapViewCameraDelegate,NMFMapViewTouchDelegate  {
        //var coord: (Double, Double)
        @Binding var cameraCoord : (Double, Double)
        
        init(_ cameraCoord: Binding<(Double, Double)>) {
            //self.coord = coord
            self._cameraCoord = cameraCoord
            
            
        }
        
        // MARK: - 카메라 이동시 발생하는 Delegate
        // 카메라의 움직임이 시작할 때 호출
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    //        print("카메라 변경 - reason: \(reason)")
        }

        // 카메라가 움직이고 있을 때 호출
        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {

        }

        // 카메라의 움직임이 끝났을 때 호출
        func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
            
            // 카메라 좌표 위치가 미세하게 계속 변해서 소수점 다섯자리까지만 비교하여 카메라좌표 및 중앙마커 변경
            let point = (round(mapView.cameraPosition.target.lat*100000)/100000.0,
                         round(mapView.cameraPosition.target.lng*100000)/100000.0)
            if (round(cameraCoord.0*100000)/100000.0,
                round(cameraCoord.1*100000)/100000.0) != point {
                cameraCoord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
            }
            print("현재 카메라 좌표 : \(cameraCoord)")
        }
        
        
        
        // MARK: - 지도 터치에 이용되는 Delegate
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("Map Tapped")
            let a = mapView.projection.point(from: NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1))
            print("실제 UI 상 좌표 \(a)")
        }
        
    }
    
}
