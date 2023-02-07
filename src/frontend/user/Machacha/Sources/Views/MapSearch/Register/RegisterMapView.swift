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
    @ObservedObject var tabbarManager = TabBarManager.shared
    @ObservedObject var mapSerachViewModel = MapSearchViewModel() //현재 위치
    @State var cameraCoord : (Double,Double) = (37.56621548663492, 126.99223256544298) // 카메라 위치
    //@State var coordinate: (Double, Double) = (37.566249, 126.992227)
    @State var isTap: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                    NavigationLink(destination: RegisterView(cameraCoord: cameraCoord)) {
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
                RegisterNaverMap(cameraCoord: $cameraCoord)
                    .ignoresSafeArea(.all, edges: [.top,.bottom])
            }
            .onAppear {
                //mapSerachViewModel.checkIfLocationServicesIsEnabled()
                //cameraCoord = mapSerachViewModel.coord
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
