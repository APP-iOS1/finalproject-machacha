


import SwiftUI
import NMapsMap

struct RegisterNaverMap: UIViewRepresentable {
    @Binding var coord: (Double, Double)
    @Binding var cameraCoord : (Double,Double)
    @State var markers : [NMFMarker] = [NMFMarker(position: NMGLatLng(lat: 37.566249, lng: 126.992227))]
    func makeCoordinator() -> NMCoordinator {
        NMCoordinator(coord,$cameraCoord,$markers)
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
        let cameraCoord = NMGLatLng(lat: coord.0, lng: coord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraCoord)
        view.mapView.moveCamera(cameraUpdate)
        //let a = view.mapView.projection.point(from: NMGLatLng(lat: coord.0, lng: coord.1))
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
        var coord: (Double, Double)
        @Binding var cameraCoord : (Double, Double)
        @Binding var markers : [NMFMarker]
        
        init(_ coord: (Double, Double), _ cameraCoord: Binding<(Double, Double)>, _ markers : Binding<[NMFMarker]>) {
            self.coord = coord
            self._cameraCoord = cameraCoord
            self._markers = markers
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
            let point = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
            if cameraCoord != point {
                cameraCoord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
                marker.isHideCollidedMarkers = true
                marker.mapView = mapView
                markers.append(marker)
                if !markers.isEmpty {
                    let removeMarker = markers.removeFirst()
                    removeMarker.mapView = nil
                }
                print("중앙 마커 이동")
            }
            print("현재 카메라 좌표 : \(coord)")
        }
        
        
        
        // MARK: - 지도 터치에 이용되는 Delegate
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("Map Tapped")
        }
        
    }
    
}
