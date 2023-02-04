//
//  MapViewModel.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/02/04.
//

import Foundation
import NMapsMap

final class MapViewModel: ObservableObject {
    typealias Pos = (Double, Double)
    
    var foodCarts: [FoodCart] = []
    @Published var markers: [NMFMarker] = []
    @Published var cameraPos: Pos = (0, 0)
    @Published var zoomLevel = 17
    
//    init(foodCarts: [FoodCart], cameraPos: Pos) {
//        self.foodCarts = foodCarts
//        self.cameraPos = cameraPos
//    }
    
    // MARK: - foodCart fetch 함수 -> 홈뷰와 합칠 예정
//    @MainActor
//    func fetchFoodCarts() async throws -> [FoodCart] {
//        do {
//
//        } catch {
//
//        }
//    }
    
    
    // MARK: - 마커의 좌표를 fetch하여 영구적으로 저장
    func fetchMarkers() {
        for foodCart in foodCarts {
            let marker = NMFMarker()
            
            marker.position = NMGLatLng(lat: foodCart.geoPoint.latitude, lng: foodCart.geoPoint.longitude)
            
            let image = NMFOverlayImage(image: UIImage(named: foodCart.markerImage) ?? UIImage())
            marker.iconImage = image
            
            marker.width = CGFloat(50)
            marker.height = CGFloat(50)
        }
    }
    
    func fetchCameraPos() {
        
    }
}
