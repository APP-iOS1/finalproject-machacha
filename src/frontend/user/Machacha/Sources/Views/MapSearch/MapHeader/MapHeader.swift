//
//  MapHeaderSearch.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeader: View {
    
    var body: some View {
        VStack {
            HStack {
                // 검색 버튼 을 누를 시 네비게이션 뷰로 전환되어 검색 뷰가 표현되어야 합니다.
                Button {
                    print("Search Button Tapped")
                } label: {
                    HStack {
                        Text("장소, 식당 이름. 주소 검색")
                        Spacer()
                    }
                }
                Spacer()
                // 음성 검색을 위한 Button
                Button {
                    print("Voice Search Button Tapped")
                } label: {
                    Image(systemName: "wave.3.backward.circle")
                        .foregroundColor(.black)
                }
            }
            .padding()
            .foregroundColor(.gray)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            MapHeaderTagCell(image: "tteokboki", tag: "떡볶이")
        }.padding()
    }
}

struct MapHeaderSearch_Previews: PreviewProvider {
    static var previews: some View {
        MapHeader()
    }
}
