//
//  MCardDetailView.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI

struct MCardDetailView: View {
    
    var namespace: Namespace.ID
    var magazine: Magazine
    
    @Binding var show: Bool
    @State var appear = [false, false, false] //이게 뭘까?
    @StateObject var model: Model
    
    
    @State var viewState: CGSize = .zero
    @State var isDraggable = true
    @State var showSection = false
    @State var selectedIndex = 0
    
//    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ScrollView {
                cover // 리스트와 버튼을 제외한 저기 상위 뷰
//                content // 얘가 아래 저 리스트들
//                    .offset(y: 120)
//                    .padding(.bottom, 200)
//                    .opacity(appear[2] ? 1 : 0)
            }
            // HomeView도 scroll이고 해당 뷰도 scroll이기 때문에 그거에 대한 처리같음
            .coordinateSpace(name: "scroll")
            .onAppear { model.showDetail = true } //해당 뷰가 보이도록
            .onDisappear { model.showDetail = false }
            .background(Color("Background"))
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(isDraggable ? drag : nil)
            .ignoresSafeArea()

            button // 저기 위에 x 버튼
        }
        .onAppear {
            fadeIn()
        }
        .onChange(of: show) { _ in
            fadeOut()
        }
    } //body

    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)

            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .foregroundStyle(.black)
            .background(
                Image(magazine.image) // 저 사람 머리 사진
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(maxWidth: 500)
                    .matchedGeometryEffect(id: "image\(magazine.id)", in: namespace)
                    .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
                    .accessibilityLabel("Cover Image")
            )
            .background(
                Image(magazine.background) // 핑크 물결 배경
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(magazine.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0 ? scrollY / 1000 + 1 : 1)
                    .blur(radius: scrollY / 20)
            )
            .mask(
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30, style:
                    .continuous)
                    .matchedGeometryEffect(id: "mask\(magazine.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            )
            .overlay(
                overlayContent
                    .offset(y: scrollY > 0 ? scrollY * -0.6 : 0)
            )
        }
        .frame(height: 500)
    }

//    var content: some View {
//        VStack {
//            ForEach(Array(CourseMockData.MockData.courseSections.enumerated()), id: \.offset) { index, section in
//                if index != 0 {
//                    Divider()
//                }
//                SectionRow(section: section)
//                    .onTapGesture {
//                        selectedIndex = index
//                        showSection = true
//                    }
//            }
//        }
//        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
//        .strokeStyle(cornerRadius: 30)
//        .padding(20)
//        .sheet(isPresented: $showSection) {
//            SectionView(section: CourseMockData.MockData.courseSections[selectedIndex])
//        }
//    }

    var button: some View {
        Button {
            withAnimation(.closeCard) {
                show.toggle()
                model.showDetail.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(30)
        .ignoresSafeArea()
    }

    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(magazine.title) // SwiftUI for iOS 15
                .font(.machachaLargeTitleBold)
                .matchedGeometryEffect(id: "title\(magazine.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(magazine.subtitle) //20 sections - 3 hours
                .font(.machachaHeadlineBold)
                .opacity(appear[1] ? 1 : 0)
//                .font(.footnote.weight(.semibold))
//                .matchedGeometryEffect(id: "subtitle\(magazine.id)", in: namespace)
            
//            Text("magazine.text") //Build an iOS app for iOS 15 with custom
//                .font(.footnote)
//                .matchedGeometryEffect(id: "text\(magazine.id)", in: namespace)

            Divider()
                .opacity(appear[0] ? 1 : 0)
                .padding(.bottom, 3)
            
            VStack (alignment: .leading) {
                /*
                 Magazine(id: "CvcZaUQTF7StFGa7omZL", title: "한입 간식 : 호떡", subtitle: "명동 & 을지로 호떡 대표 맛집 TOP 3", editorPickTitle: "꿀호떡냠냠's PICK", editorCommemt: "저만의 호떡 맛집들을 공유해보려고 합니다.", image: "Illustration 1", background: "Background 1", foodCartId: ["InzqNwgl15TytWNOdIZz"], createdAt: Date(), updatedAt: Date()),
                 show:  .constant(true)
                 */
                Text(magazine.editorPickTitle)
                    .font(.machachaSubheadBold)
                    .padding(.bottom, 2)
                
                Text("\"\(magazine.editorCommemt)\"")
                    .font(.machachaSubhead)
            }
            .opacity(appear[1] ? 1 : 0)
        }
        .padding(20)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .matchedGeometryEffect(id: "blur", in: namespace)
        )
        .offset(y: 250)
        .padding(20)
    }

    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0 else { return }
                if value.startLocation.x < 100 {
                    withAnimation {
                        viewState = value.translation
                    }
                }
                if viewState.width > 120 {
                    close()
                }
            }
            .onEnded { _ in
                if viewState.width > 80 {
                    close()
                } else {
                    withAnimation {
                        viewState = .zero
                    }
                }
            }
    }

    func fadeIn() {
        var delay = 0.3
        for i in 0 ..< appear.count {
            withAnimation(.easeOut.delay(delay)) {
                appear[i] = true
                delay += 0.1
            }
        }
    }

    func fadeOut() {
        appear = Array(repeating: false, count: appear.count)
    }

    func close() {
        withAnimation(.closeCard.delay(0.3)) {
            show.toggle()
            model.showDetail.toggle()
        }

        withAnimation {
            viewState = .zero
        }

        isDraggable = false
    }
}

struct MCardDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        MCardDetailView(
            namespace: namespace,
            magazine: Magazine(id: "CvcZaUQTF7StFGa7omZL", title: "한입 간식 : 호떡", subtitle: "명동 & 을지로 호떡 대표 맛집 TOP 3", editorPickTitle: "꿀호떡냠냠's PICK", editorCommemt: "저만의 호떡 맛집들을 공유해보려고 합니다.", image: "Illustration 1", background: "Background 1", foodCartId: ["InzqNwgl15TytWNOdIZz"], createdAt: Date(), updatedAt: Date()),
            show:  .constant(true),
            model: Model())
    }
}
