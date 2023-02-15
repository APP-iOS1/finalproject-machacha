//
//  MCardView.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI

struct MCardView: View {
    
    var namespace: Namespace.ID
    var magazine: Magazine 
    
    @Binding var show: Bool

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                
                Text(magazine.title) // SwiftUI for iOS 15
                    .font(.machachaLargeTitleBold)
                    .shadow(radius: 1.6)
                    
                    // matchedGeometryEffect ?
                    // 같은 id를 가진 모든 View를 하나의 그룹으로 인식하여, 각기 다른 View라도 이 View들의 위치를 기반으로 애니메이션 궤적의 시작점과 끝점을 계산할 수 있도록 함
                    .matchedGeometryEffect(id: "title\(magazine.id)", in: namespace)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
                
                Text(magazine.subtitle) //20 sections - 3 hours
                    .font(.machachaTitle3Bold)
                    .shadow(radius: 1.6)
                    .matchedGeometryEffect(id: "subtitle\(magazine.id)", in: namespace)
                    .padding(.bottom, 10)
                    .lineLimit(1)
//                Text(magazine.text) // Build an iOS app for iOS 15 with custom layouts,
//                    .font(.footnote)
//                    .matchedGeometryEffect(id: "text\(magazine.id)", in: namespace)
                
            }.padding(20)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
//                        .fill(.red)
                        .mask(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .frame(height: 80)
                            ) //30
                        .blur(radius: 35) //원래 30
                        .matchedGeometryEffect(id: "blue\(magazine.id)", in: namespace)
                )
        }

        .foregroundStyle(.white)
//        .background(
//            Image(magazine.image) // Illustration 5 - 저 머리모양 그림
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(20)
//                .matchedGeometryEffect(id: "image\(magazine.id)", in: namespace)
//        )
        .background(
            Image(magazine.background) //Background 5 - 핑크 보라 배경
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background\(magazine.id)", in: namespace)
        )
        // mask? RoundedRectangle 모양으로 잘라내는 느낌쓰
        .mask {
            RoundedRectangle(cornerRadius: 30, style:
                .continuous)
                .matchedGeometryEffect(id: "mask\(magazine.id)", in: namespace)
        }
        .frame(height: 300)
    }
}

struct MCardView_Previews: PreviewProvider {
    @Namespace static var namespace

    static var previews: some View {
        MCardView(namespace: namespace,
                  magazine: Magazine(id: "CvcZaUQTF7StFGa7omZL", title: "한입 간식 : 호떡", subtitle: "명동 & 을지로 호떡 대표 맛집 TOP 3", editorPickTitle: "꿀호떡냠냠's PICK", editorCommemt: "저만의 호떡 맛집들을 공유해보려고 합니다.", image: "Illustration 1", background: "Background 1", foodCartId: ["InzqNwgl15TytWNOdIZz"], createdAt: Date(), updatedAt: Date()),
                  show: .constant(true))
    }
}
