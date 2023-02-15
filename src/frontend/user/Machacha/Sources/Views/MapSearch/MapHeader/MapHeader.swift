//
//  MapHeaderSearch.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeader: View {
    
    @State var isTap = false
    @Binding var currentIndex: Int
    @Binding var cameraPosition: LatLng
    @Binding var fromSearchView: Bool
    
    let cellList = ["mainIcon", "bbungbread2", "fishcake2", "sweetpotato2", "tteokboki2", "takoyaki", "hotteok", "skewers", "dessert", "beverage", "store2"]
    
    var body: some View {
        VStack {
            HStack {
                // 검색 버튼 을 누를 시 네비게이션 뷰로 전환되어 검색 뷰가 표현되어야 합니다.
                Button {
                    isTap = true
                } label: {
                    HStack {
                        Text("장소, 식당 이름. 주소 검색")
                            .foregroundColor(Color("textColor2"))
                        Spacer()
                    }
                }
                Spacer()
//                VoiceView(text: $text, voiceViewModel: voiceViewModel)
//                    .frame(width: 40, height: 40)
//                    .padding(.bottom, 10)

            }
            .padding()
            .background(Color("cellColor"))
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding([.leading, .trailing, .top], 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(cellList, id: \.self) { item in
                        MapHeaderTagCell(currentIndex: $currentIndex, cameraPosition: $cameraPosition, image: item)
                    }
                }
            }
            .padding([.leading], 13)    //tag cell의 padding과 값을 맞춘거임
        }
        .navigationDestination(isPresented: $isTap) {
            SearchView(currentIndex: $currentIndex, fromSearchView: $fromSearchView)
        }
    }
}

struct MapHeaderSearch_Previews: PreviewProvider {
    @State static var currentIndex = 0
    @State static var cameraPosition = (0.0, 0.0)
    @State static var fromSearchView = false
    static var previews: some View {
        MapHeader(currentIndex: $currentIndex, cameraPosition: $cameraPosition, fromSearchView: $fromSearchView)
    }
}
