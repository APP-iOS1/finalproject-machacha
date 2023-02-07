//
//  MapViewModel.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/02/04.
//

import Foundation
import NMapsMap
import Combine

final class MapSearchViewModel: ObservableObject {
    
    var foodCarts: [FoodCart] = []
    @Published var markers: [NMFMarker] = []
    @Published var cameraPosition: LatLng = (0, 0)
    @Published var zoomLevel: Double = 17.0
    
    private var cancellables = Set<AnyCancellable>()
    
//    init(foodCarts: [FoodCart], cameraPos: Pos) {
//        self.foodCarts = foodCarts
//        self.cameraPos = cameraPos
//    }
    
    // MARK: - combine을 이용한 foodCart Fetch
    func fetchFoodCarts() {
        foodCarts.removeAll()
        FirebaseService.fetchFoodCarts()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case.finished:
                    return
                }
            } receiveValue: { [weak self] foodCarts in
                self?.foodCarts = foodCarts
                print("fetchFoodcart \(foodCarts)")
            }
            .store(in: &cancellables)

    }
    
    func fetchSortedMenu(by bestMenu: Int) {
        foodCarts.removeAll()
        FirebaseService.fetchSortedFoodCarts(by: bestMenu)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case.finished:
                    return
                }
            } receiveValue: { [weak self] foodCarts in
                self?.foodCarts = foodCarts
            }
            .store(in: &cancellables)
    }
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
