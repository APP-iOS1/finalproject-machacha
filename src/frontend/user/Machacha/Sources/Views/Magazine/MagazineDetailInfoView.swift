//
//  MagazineDetailInfoView.swift
//  Machacha
//
//  Created by Sue on 2023/02/01.
//

import SwiftUI

// 임시로 작업
struct MagazineDetailInfoView: View {
    var body: some View {
        VStack (spacing: 30) {
            VStack (alignment: .leading, spacing: 20) {
                Text("큐레이터의 한마디")
                    .foregroundColor(.gray)
                Text("봄바람을 싸인 있을 끓는다. 열락의 오직 든 철환하였는가? 그들은 가치를 바이며")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.vertical, 30)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            ForEach(0 ..< 4) { item in
                VStack (alignment: .leading, spacing: 7){
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("회화 제과")
                        Spacer()
                    }
                    .font(.title)
                    .bold()
                    
                    Text("부산 부산진구 전포대로 246번길 6 1층 상가")
                        .foregroundColor(.gray)
                }
          
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    Image("p0")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    Image("p1")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            }
            
        }
        .padding(.horizontal, 20)
    }
}

struct MagazineDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineDetailInfoView()
    }
}
