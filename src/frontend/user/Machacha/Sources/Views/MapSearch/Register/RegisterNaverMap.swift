


import SwiftUI
import NMapsMap

struct RegisterNaverMap: UIViewRepresentable {
    @Binding var coord: (Double, Double)
    @Binding var cameraCoord : (Double,Double)
    func makeCoordinator() -> NMCoordinator {
        NMCoordinator(coord,cameraCoord)
    }

    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
//        view.showLocationButton = true
//
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.touchDelegate = (context.coordinator)
        return view
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let cameraCoord = NMGLatLng(lat: cameraCoord.0, lng: cameraCoord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraCoord)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.3
        uiView.mapView.moveCamera(cameraUpdate)
        print("update: \(cameraCoord)")
    }
    
    class NMCoordinator: NSObject ,NMFMapViewCameraDelegate,NMFMapViewTouchDelegate  {
        var coord: (Double, Double)
        var cameraCoord : (Double, Double)
        init(_ coord: (Double, Double), _ cameraCoord: (Double, Double)) {
            self.coord = coord
            self.cameraCoord = cameraCoord
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
            //coord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
            cameraCoord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
            print("현재 카메라 좌표 : \(cameraCoord)")
        }
        
        // MARK: - 지도 터치에 이용되는 Delegate
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            print("Map Tapped")
        }
        
    }
    
}

//class NMCoordinator: NSObject {
//    var coord: (Double, Double)
//    init(_ coord: (Double, Double)) {
//        self.coord = coord
//    }
//}
//
//// MARK: - 카메라 이동시 발생하는 Delegate
//extension NMCoordinator: NMFMapViewCameraDelegate {
//    // 카메라의 움직임이 시작할 때 호출
//    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
////        print("카메라 변경 - reason: \(reason)")
//    }
//
//    // 카메라가 움직이고 있을 때 호출
//    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//
//    }
//
//    // 카메라의 움직임이 끝났을 때 호출
//    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//        coord = (mapView.cameraPosition.target.lat, mapView.cameraPosition.target.lng)
//        print("현재 카메라 좌표 : \(coord)")
//    }
//}
//
//// MARK: - 지도 터치에 이용되는 Delegate
//extension NMCoordinator: NMFMapViewTouchDelegate {
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        print("Map Tapped")
//    }
//}
