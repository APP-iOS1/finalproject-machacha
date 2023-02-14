//
//  RegisterView.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/31.
//

import SwiftUI

//보라색 에러때문인지 뷰 컴포넌트를 하나 지우거나 바꾸면 맵을 무한히 불러옴 (updateUIView 계속)

struct RegisterMapView: View {
    
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var locationManager : LocationManager
    @EnvironmentObject  var mapSearchViewModel : MapSearchViewModel
    @EnvironmentObject var foodCartViewModel : FoodCartViewModel
    
    @ObservedObject var tabbarManager = TabBarManager.shared
    
    @State var isLoading : Bool = true
    @State var cameraCoord : (Double,Double) = (37.56621548663492, 126.99223256544298) // 카메라 위치
    //@State var coordinate: (Double, Double) = (37.566249, 126.992227)
    
    //RegisterView 에 전달할 변수
    @State private var name : String = ""
    @State private var paymentOpt : [Bool] = Array(repeating: false, count: 3)
    @State private var openingDays : [Bool] = Array(repeating: false, count: 7)
    @State private var menu : [String : Int] = [:]
    @State private var grade : Double = 0
    @State private var bestMenu : Int = -1
    
    @State private var menuCnt : Int = 1
    @State private var menuName : String = ""
    @State private var menuPrice : String = ""
    
    var body: some View {
        NavigationStack{
            Group{
                if isLoading {
                    ProgressView()
                }else{
                    ZStack {
                        // 추후에 input model 새로만들어서 한번에 넘겨주는게 좋을듯
                        NavigationLink(destination: RegisterView(name: $name, paymentOpt: $paymentOpt, openingDays: $openingDays, menu: $menu, grade: $grade, bestMenu: $bestMenu, menuCnt: $menuCnt, menuName: $menuName, menuPrice: $menuPrice, cameraCoord: cameraCoord)) {
                            Image("locationIcon")
                                .resizable()
                                .renderingMode(.original)
                                .buttonStyle(.plain)
                                .scaledToFit()
                                .frame(width: Screen.maxWidth*0.4, height: Screen.maxWidth*0.4)
                        }
                        //위도경도를 화면상 CGPoint로 변환하여 설정함(기기마다 다르게 설정해줘야할듯 , 현재 14 pro 기준)
                        .position(CGPoint(x:196.5,y:377.2))
                        .zIndex(1)
                        
                        RegisterNaverMap(cameraCoord: $cameraCoord,userCoord: locationManager.userLocation ,foodCarts: foodCartViewModel.foodCarts)
                            .ignoresSafeArea(.all, edges: [.bottom])
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Color3"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                        Text("가게 등록")
                        .foregroundColor(Color("bgColor"))
                        .font(.machachaHeadlineBold)
                            .accessibilityAddTraits(.isHeader)
                    }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        tabbarManager.isShowingModal = false
                        tabbarManager.curTabSelection = tabbarManager.preTabSelection
                    } label: {
                            Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(Color("bgColor"))
                    }
                } // ToolbarItem
            })
            .onAppear {
                if isLoading{
                    Task {
                        locationManager.checkIfLocationServicesIsEnabled() //현재위치 받아오기
                        //cameraCoord = locationManager.coord
                        mapSearchViewModel.fetchFoodCarts()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            cameraCoord = locationManager.coord
                            isLoading = false
                        } // DispatchQueue
                    } // Task
                }
            }
        }
        
    }
}

//struct RegisterMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterMapView()
//    }
//}
