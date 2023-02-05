


import SwiftUI
import NMapsMap

struct RegisterNaverMap: UIViewRepresentable {
    @Binding var cameraCoord : (Double,Double)
    
    //카메라가 이동할때마다 중앙 마커를 담아놓을 배열
    @State var markers : [NMFMarker] = [NMFMarker(position: NMGLatLng(lat: 37.566249, lng: 126.992227))]
    func makeCoordinator() -> NMCoordinator {
        NMCoordinator($cameraCoord,$markers)
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
        //var coord: (Double, Double)
        @Binding var cameraCoord : (Double, Double)
        @Binding var markers : [NMFMarker]
        
        init(_ cameraCoord: Binding<(Double, Double)>, _ markers : Binding<[NMFMarker]>) {
            //self.coord = coord
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
            
            // 카메라 좌표 위치가 미세하게 계속 변해서 소수점 다섯자리까지만 비교하여 카메라좌표 및 중앙마커 변경
            let point = (round(mapView.cameraPosition.target.lat*100000)/100000.0,
                         round(mapView.cameraPosition.target.lng*100000)/100000.0)
            if (round(cameraCoord.0*100000)/100000.0,
                round(cameraCoord.1*100000)/100000.0) != point {
                cameraCoord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
                
                //카메라 이동시 카메라 중앙 마커 이동
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
                marker.isHideCollidedMarkers = true
                marker.mapView = mapView
                markers.append(marker)
                //이전 중앙 마커 해제
                if !markers.isEmpty {
                    let removeMarker = markers.removeFirst()
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
