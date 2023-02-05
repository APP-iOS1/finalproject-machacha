//
//  RegisterView.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/31.
//

import SwiftUI

struct RegisterMapView: View {
    @ObservedObject var mapSerachViewModel = MapSearchViewModel() //현재 위치
    @State var cameraCoord : (Double,Double) = (37.566249, 126.992227) // 카메라 위치
    //@State var coordinate: (Double, Double) = (37.566249, 126.992227)
    @State var isTap: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color("Color3"))
                    .frame(width: 20)
                    .zIndex(1)
                RegisterNaverMap(coord: $mapSerachViewModel.coord, cameraCoord: $cameraCoord)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                mapSerachViewModel.checkIfLocationServicesIsEnabled()
                cameraCoord = mapSerachViewModel.coord
            }
            .onChange(of: cameraCoord.0) { coord in
                print("변화중 : \(cameraCoord)")
            }
            
            Text("카메라 위치: \(cameraCoord.0), \(cameraCoord.1)")
            NavigationLink(destination: RegisterView(cameraCoord: cameraCoord)) {
                Text("등록")
            }
        }
    }
}

//struct RegisterMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterMapView()
//    }
//}


struct Coord : Equatable {
    var latitude : Double
    var longitude : Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func ==(left: Coord, right: Coord) -> Bool {          // Needed to be Equatable
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
}
