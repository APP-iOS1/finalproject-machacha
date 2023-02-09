//
//  MCardMapView.swift
//  Machacha
//
//  Created by Sue on 2023/02/03.
//

import SwiftUI
import NMapsMap

struct MCardMapView: View {
    
    @StateObject var model: Model
    @Environment(\.dismiss) var dismiss
    @State var coord: (Double, Double) = (126.976928, 37.576045) // 시작 광화문 좌표
    
    var body: some View {
        ZStack {
            
            VStack {
                Button(action: {coord = (129.05562775, 35.1379222)}) {
                    Text("Move to Busan")
                }
                Button(action: {coord = (127.269311, 37.413294)}) {
                    Text("Move to Seoul somewhere")
                }
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(30)
            }
            .zIndex(1)

            MagazineMapView(coord)
                .edgesIgnoringSafeArea(.top)
        }
    }//body
}

// UIViewRepresentable 프로토콜을 준수하기 위해서는 makeUIView와 updateUIView 필요
struct MagazineMapView: UIViewRepresentable {
    
    var coord: (Double, Double)
    
    init(_ coord: (Double, Double)) {
        self.coord = coord
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        let marker = NMFMarker() // 마커 객체를 생성
    
//        let locationOverlay = view.mapView.locationOverlay //위치 오버레이 객체를 가져옴
        
        
        // MARK: - 기본 Map에 대한 내용
        view.showLocationButton = true // 좌측 하단에 사용자 현재 위치 가져오는 버튼
        
        view.mapView.mapType = .basic //지도 타입 설정 (.none : 지도x. 단, 오버레이는 여전히 나타남)
        view.mapView.positionMode = .direction

        
        //MARK: - Marker
        marker.position = NMGLatLng(lat: 37.57661, lng: 126.97694) // position 속성 - 좌표설정
//        marker.iconImage = NMF_MARKER_IMAGE_BLACK
//        marker.iconTintColor = UIColor.red

        marker.captionText = "멋쟁이 사자처럼"
        marker.captionTextSize = 16
        marker.mapView = view.mapView // mapView 속성 - 지도 객체를 지정하면 마커가 나타남
        //marker.iconImage = NMFOverlayImage(name: "bbungbread")
        
        //MARK: - Zoom
        view.showZoomControls = true
        view.mapView.zoomLevel = 17 // 화면 처음 켰을 때의 줌 레벨
        view.mapView.minZoomLevel = 9.4 // - 에 대한
        view.mapView.maxZoomLevel = 18.5 // +
        
        // 심벌의 크기를 변경 : 0~2의 비율로 지정
        view.mapView.symbolScale = 1.2
 
        
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        
        return view
    }
    
    
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
        print("Update UI View function ")
    }
    

    
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var coord: (Double, Double)
        init(_ coord: (Double, Double)) {
            self.coord = coord
        }
        
        // 카메라 움직이는 동안 계속 작동
        // (사용자가 화면을 드래그하는 동안)
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
            print("카메라 변경 - reason: \(reason)")
        }
        
        // 사용자가 드래그를 끝낸 후 바로 호출
        // 근데 기존 카메라가 바라 보고 있는 곳(프레임)으로부터
        // 카메라가 움직이면
        // 여러번 호출
        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
            print("cameraIsChangingByReason")
        }
  
    }
    
}



struct MCardMapView_Previews: PreviewProvider {
    static var previews: some View {
        MCardMapView(model: Model())
    }
}
