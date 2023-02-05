//
//  MapSearchView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MapSearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var mapSearchViewModel: MapSearchViewModel
    @State var cameraCoord: (Double, Double) = (37.566249, 126.992227)
    @State var currentIndex: Int = 0
    @State var isTap: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MapHeader()
                    Spacer()
                    
                    Button {
                        print("현재 위치 조회")
                        cameraCoord = locationManager.coord
                    } label: {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30)
                                    .shadow(radius: 10)
                                Image(systemName: "scope")
                                    .foregroundColor(Color("Color3"))
                            }
                        }.padding()

                    }

                    
                    SnapCarousel(index: $currentIndex, items: mapSearchViewModel.foodCarts, coord: $cameraCoord) { foodCart in
                        MapFooterCell(foodCart: foodCart, isFocus: false)
                            .aspectRatio(contentMode: .fill)
                            .padding(.vertical, Screen.maxHeight - 400)
                            .onTapGesture {
                                self.isTap = true
                            }
                    }
                    
                }
                .navigationDestination(isPresented: $isTap) {
                    // content뷰에서 fetch를 하기 때문에 프리뷰에서 에러가 발생하기 때문에 주석처리함
//                    TestView(name: mapSearchViewModel.foodCarts[currentIndex].name)
//                    DetailView(selectedStore: mapSearchViewModel.foodCarts[currentIndex])
                }
                .zIndex(1)
                NaverMap(coord: $cameraCoord, currentIndex: $currentIndex, foodCarts: mapSearchViewModel.foodCarts)
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                cameraCoord = locationManager.coord
            }
        }
    }
    @ViewBuilder private func TestView(name: String) -> some View {
        VStack {
            Text("가게 이름 : \(name)")
        }
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
            .environmentObject(LocationManager())
            .environmentObject(MapSearchViewModel())
    }
}
