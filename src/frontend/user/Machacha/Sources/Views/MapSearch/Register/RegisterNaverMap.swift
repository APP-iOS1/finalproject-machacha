


import SwiftUI
import NMapsMap

struct RegisterNaverMap: UIViewRepresentable {
    @Binding var cameraCoord : (Double,Double)
    var foodCarts: [FoodCart]
    var markers: [NMFMarker] = []
    
    //카메라가 이동할때마다 중앙 마커를 담아놓을 배열
    @State var centerMarkers : [NMFMarker] = [NMFMarker(position: NMGLatLng(lat: 37.566249, lng: 126.992227))]
    
    func makeCoordinator() -> NMCoordinator {
        NMCoordinator($cameraCoord,$centerMarkers)
    }
    
    init(cameraCoord: Binding<(Double,Double)>,foodCarts: [FoodCart]) {
        self.foodCarts = foodCarts
        self._cameraCoord = cameraCoord
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
        @Binding var centerMarkers : [NMFMarker]
        
        init(_ cameraCoord: Binding<(Double, Double)>, _ centerMarkers : Binding<[NMFMarker]>) {
            //self.coord = coord
            self._cameraCoord = cameraCoord
            self._centerMarkers = centerMarkers
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
                
                //카메라 이동시 카메라 중앙 마커 이동
                let centerMarker = NMFMarker()
                centerMarker.position = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
                centerMarker.isHideCollidedMarkers = true
                centerMarker.mapView = mapView
                centerMarkers.append(centerMarker)
                //이전 중앙 마커 해제
                if !centerMarkers.isEmpty {
                    let removeMarker = centerMarkers.removeFirst()
                    removeMarker.mapView = nil
                }
                print("중앙 마커 이동")
            }
            print("현재 카메라 좌표 : \(cameraCoord)")
        }
        
        
        
        // MARK: - 지도 터치에 이용되는 Delegate
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("Map Tapped")
        }
        
    }
    
}
