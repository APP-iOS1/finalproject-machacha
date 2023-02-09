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
            ZStack {
                    // 추후에 input model 새로만들어서 한번에 넘겨주는게 좋을듯
                    NavigationLink(destination: RegisterView(name: $name, paymentOpt: $paymentOpt, openingDays: $openingDays, menu: $menu, grade: $grade, bestMenu: $bestMenu, menuCnt: $menuCnt, menuName: $menuName, menuPrice: $menuPrice, cameraCoord: cameraCoord)) {
                            HStack{
                                Text("이 위치로 등록하기")
                                    .bold()
                                Image(systemName: "chevron.right")
                            }
                            .font(.title3)
                            .foregroundColor(Color("Color3"))
                            .padding(10)
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Color4"))
                                    .zIndex(3)
                            }
                }
                .padding(.bottom,250)
                .zIndex(2)
                
            Rectangle()
                .fill(Color("Color4"))
                .frame(width:5,height: Screen.maxHeight*0.04)
                .padding(.bottom,200)
                .zIndex(1)
                RegisterNaverMap(cameraCoord: $cameraCoord,foodCarts: foodCartViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: [.top,.bottom])
            }
            .onAppear {
                //mapSerachViewModel.checkIfLocationServicesIsEnabled()
                //cameraCoord = mapSerachViewModel.coord
                mapSearchViewModel.fetchFoodCarts()
                Task{
                    await MainActor.run{
                        print("onAppear lm: \(locationManager.coord)")
                        cameraCoord = locationManager.coord
                        print("onAppear cc: \(cameraCoord)")
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        tabbarManager.isShowingModal = false
                        tabbarManager.curTabSelection = tabbarManager.preTabSelection
                        tabbarManager.barOffset = tabbarManager.offsetList[tabbarManager.preIndex]
                    } label: {
                        HStack{
                            Image(systemName: "chevron.left")
                                .fontWeight(.bold)
                            Text("뒤로")
                                .font(.machachaHeadlineBold)
                        }
                    }
                } // ToolbarItem
            })
        }
        
    }
}

//struct RegisterMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterMapView()
//    }
//}
