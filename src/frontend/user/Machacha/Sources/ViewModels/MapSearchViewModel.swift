//
//  MapViewModel.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/02/04.
//

import Foundation
import NMapsMap
import Combine
import CoreLocation

final class MapSearchViewModel: NSObject ,ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var userLocation: LatLng = (0.0, 0.0)
    @Published var foodCarts: [FoodCart] = []
    @Published var markers: [NMFMarker] = []
    @Published var cameraPosition: LatLng = (0, 0)
    @Published var zoomLevel: Double = 17.0
    
    private var cancellables = Set<AnyCancellable>()
    
    
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
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            cameraPosition = userLocation
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationServicesEnabled() async -> Bool {
        CLLocationManager.locationServicesEnabled()
    }
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
    @MainActor
    func sortedBy(by bestMenu: Int) {
        foodCarts = foodCarts.filter{ $0.bestMenu == bestMenu }
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
