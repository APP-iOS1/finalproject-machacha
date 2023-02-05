//
//  RegisterView.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/31.
//

import SwiftUI

//보라색 에러때문인지 뷰 컴포넌트를 하나지우면 맵을 무한히 불러옴 (updateUIView 계속)

struct RegisterMapView: View {
    @ObservedObject var mapSerachViewModel = MapSearchViewModel() //현재 위치
    @State var cameraCoord : (Double,Double) = (37.56621548663492, 126.99223256544298) // 카메라 위치
    //@State var coordinate: (Double, Double) = (37.566249, 126.992227)
    @State var isTap: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
//                VStack{
//                    Spacer()
//                    NavigationLink(destination: RegisterView(cameraCoord: cameraCoord)) {
//                        Text("이 위치로 제보하기")
//                    }
//                }
//                .zIndex(1)
                RegisterNaverMap(cameraCoord: $cameraCoord)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                //mapSerachViewModel.checkIfLocationServicesIsEnabled()
                //cameraCoord = mapSerachViewModel.coord
            }
            
            Text("카메라 위치: \(cameraCoord.0), \(cameraCoord.1)")
            NavigationLink(destination: RegisterView(cameraCoord: cameraCoord)) {
                Text("이 위치로 제보하기")
                    .font(.machachaTitle3)
                    .foregroundColor(Color("Color3"))
                    .padding()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("Color3"))
                    .opacity(0.1)
            }
            .padding()
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

/*
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
     @State var isTap: Bool = false
     
     var body: some View {
         VStack {
             ZStack {
                 VStack{
                     Spacer()
                     NavigationLink(destination: RegisterView(cameraCoord: cameraCoord)) {
                         Text("이 위치로 제보하기")
                             .font(.machachaTitle3)
                             .foregroundColor(Color("Color3"))
                     }
                     .tint(Color("Color3"))
                 }
                 .zIndex(1)
                 RegisterNaverMap(coord: $mapSerachViewModel.coord, cameraCoord: $cameraCoord)
                     .ignoresSafeArea(.all, edges: .top)
             }
             .onAppear {
                 mapSerachViewModel.checkIfLocationServicesIsEnabled()
                 cameraCoord = mapSerachViewModel.coord
             }
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


 */
