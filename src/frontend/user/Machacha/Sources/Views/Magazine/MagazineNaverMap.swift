//
//  MagazineNaverMap.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/18.
//

import SwiftUI
import NMapsMap
import FirebaseFirestore

// 핀꼽고 사용자 위치만 표시해주기!
// (후순위 기술적 도전) 구글 길찾기 api (도보)

struct MagazineNaverMapView: View {
    
    @StateObject var model: Model
    @Binding var showMap: Bool
    @Environment(\.dismiss) var dismiss
    var foodcart: [FoodCart]
    
    //순서가 타꼬야끼 -> 슈메이커 -> 명동할머니
    // FE359DC9-5B77-4F9C-933E-7042B49B2F2F
    //CA22A43A-EF4D-4DDF-8C4D-E4218AE704A5
    //21974A04-39FA-4D9B-9959-34A181598BA0
    
    var machaM: [FoodCart] = [
        FoodCart(id: "FE359DC9-5B77-4F9C-933E-7042B49B2F2F", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.563618491562295, longitude: 126.98298431817352) , region: "", name: "눈스퀘어 앞 타코야끼", address: "", visitedCnt: 1, favoriteCnt: 1, paymentOpt: [true, true, true], openingDays: [false, true], menu: ["떡볶이": 3000], bestMenu: 1, imageId: [""], grade: 1, reportCnt: 1, reviewId: [], registerId: ""),
        
        FoodCart(id: "FE359DC9-5B77-4F9C-933E-7042B49B2F2F", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.5637274045244, longitude: 126.98381260461002) , region: "", name: "슈메이커 앞 붕어빵", address: "", visitedCnt: 1, favoriteCnt: 1, paymentOpt: [true, true, true], openingDays: [false, true], menu: ["떡볶이": 3000], bestMenu: 1, imageId: [""], grade: 1, reportCnt: 1, reviewId: [], registerId: ""),
        
        FoodCart(id: "FE359DC9-5B77-4F9C-933E-7042B49B2F2F", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.56377404294155, longitude: 126.98284657925063) , region: "", name: "명동할머니 쌀 떡볶이", address: "", visitedCnt: 1, favoriteCnt: 1, paymentOpt: [true, true, true], openingDays: [false, true], menu: ["떡볶이": 3000], bestMenu: 1, imageId: [""], grade: 1, reportCnt: 1, reviewId: [], registerId: "")
        
    ]
    
    var coord: (Double, Double) = (37.563618491562295, 126.98298431817352)
    
    // GeoPoint(latitude: 37.563618491562295, longitude: 126.98298431817352) 타코야끼
    // 
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showMap.toggle()
                } label: {
                    Text("닫기")
                        .font(.machachaTitle2Bold)
                        .foregroundColor(Color("Color3"))
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                


            }
            
            MagazineNaverMap(coord: coord, foodCarts: foodcart)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}


struct MagazineNaverMap: UIViewRepresentable {
     //37.561630, 126.984844
//    @Binding var coord: (Double, Double)
    var coord: (Double, Double)
    
    var foodCarts: [FoodCart]
    var markers: [NMFMarker] = []
    
    // 경로 그려주는거 실험용
//    var routePoints: [NMGLatLng] = [
//        NMGLatLng(lat: 37.5636684, lng: 126.9829819),
//        NMGLatLng(lat: 37.5636742, lng: 126.9834744),
//        NMGLatLng(lat: 37.5637025, lng: 126.9837686),
//        NMGLatLng(lat: 37.5637072, lng: 126.9838150),
//        NMGLatLng(lat: 37.5637299, lng: 126.9840481),
//        NMGLatLng(lat: 37.5637743, lng: 126.9845120),
//        NMGLatLng(lat: 37.5633915, lng: 126.9845747),
//        NMGLatLng(lat: 37.5633085, lng: 126.9841518),
//        NMGLatLng(lat: 37.5632871, lng: 126.9840092),
//        NMGLatLng(lat: 37.5632537, lng: 126.9837921),
//        NMGLatLng(lat: 37.5632323, lng: 126.9836224),
//        NMGLatLng(lat: 37.5636742, lng: 126.9834744),
//        NMGLatLng(lat: 37.5636669, lng: 126.9828483)
//    ]
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    init( coord: (Double, Double), foodCarts: [FoodCart]) {
        self.coord = coord
        self.foodCarts = foodCarts
        for foodCart in foodCarts {
            let marker = NMFMarker() // 마커 객체를 생성
            let latitude = foodCart.geoPoint.latitude
            let longitude = foodCart.geoPoint.longitude
//            let routePoint = NMGLatLng(lat: latitude, lng: longitude)
            
            marker.position = NMGLatLng(lat: latitude, lng: longitude)
            
//            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
//            marker.iconImage = image
            marker.captionText = foodCart.name
            self.markers.append(marker)
//            self.routePoints.append(marker.position)
        }
        
        
    }
    
    
    // MARK: - Map을 그리고 생성하는 메서드
    func makeUIView(context: Context) -> some NMFNaverMapView {
        let view = NMFNaverMapView()
        let pathOverlay = NMFPath() // 오버레이로 경로선 그려주기 위해
        
        // MARK: - 기본 Map에 대한 내용
        view.mapView.mapType = .basic //지도 타입 설정 (.none : 지도x. 단, 오버레이는 여전히 나타남)
        view.mapView.positionMode = .direction
        view.showLocationButton = true // 좌측 하단에 사용자 현재 위치 가져오는 버튼
        
        //MARK: - Zoom
        view.showZoomControls = true
        view.mapView.zoomLevel = 17 // 화면 처음 켰을 때의 줌 레벨
        view.mapView.minZoomLevel = 9.4 // - 에 대한
        view.mapView.maxZoomLevel = 18.5 // +
        
        for marker in markers {

            marker.mapView = view.mapView
        }
        
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.touchDelegate = context.coordinator
        
//        pathOverlay.passedOutlineColor = UIColor.green
//        pathOverlay.outlineColor = UIColor.green
//        pathOverlay.outlineWidth = 2.5
//        pathOverlay.path = NMGLineString(points: routePoints)
//        pathOverlay.mapView =  view.mapView
        
        return view
    }
    
    // MARK: - Map이 업데이트 될 때 발생하는 메서드
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        var coord = NMGLatLng(lat: coord.0, lng: coord.1)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.3
        uiView.mapView.moveCamera(cameraUpdate)

    
    }
}

class MCoordinator: NSObject {
    var coord: (Double, Double)
    init(_ coord: (Double, Double)) {
        self.coord = coord
    }
}

// MARK: - 카메라 이동시 발생하는 Delegate
extension MCoordinator: NMFMapViewCameraDelegate {
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
//        print("현재 카메라 좌표 : \(coord)")
    }
}


struct MagazineNaverMapView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineNaverMapView(model: Model(), showMap: .constant(true), foodcart: FoodCart.getListDummy())
    }
}
