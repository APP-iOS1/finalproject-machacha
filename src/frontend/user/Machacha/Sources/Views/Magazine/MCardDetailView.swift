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
    // 강사님 피드백
    // 1. 카드가 열릴 때 :
    // 2. 카드가 닫힐 때 : 안에 내용물들이 사라지고 카드가 닫혀야 한다.
    // 즉, 가게 리스트, 에디터 관련 글, 글이 담긴 박스, 디바이더가 먼저 사라지고 카드가 남아야 함
    
    // appear[0] : Divider
    // appear[1] : 에디터's PICK, 한 마디
    // appear[2] : content 전체 (아래 리스트들)
    @StateObject var model: Model
    @StateObject var magazineVM: MagazineViewModel
    
    @State var viewState: CGSize = .zero
    @State var showMap = false
    
    @State var isDraggable = true
    @State var selectedIndex = 0
    @State var isLoading = true //progressview에 사용 예정
    @State var opacity: Double = 0.8
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ScrollView {
            
                cover // 리스트와 버튼을 제외한 저기 상위 뷰
                // 스켈레톤 뷰 무조건 필요
                // 데이터 완전히 로드되기 전까지 너무 텅비어 있음
   
                if isLoading {
                    ProgressView()
                        .offset(y: 50) //76
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(2.6)

                } else {
                    content // 얘가 아래 저 리스트들
                        .offset(y: 109) //76
                        .padding(.bottom, 220)
                        .opacity(appear[2] ? 1 : 0)
                }
         
                
       
//                content // 얘가 아래 저 리스트들
//                    .offset(y: 109) //76
//                    .padding(.bottom, 220)
//                    .opacity(appear[2] ? 1 : 0)
                    
              
                
//                Text("\(magazine.foodCartId.count)")
            }
            // HomeView도 scroll이고 해당 뷰도 scroll이기 때문에 그거에 대한 처리같음
            .coordinateSpace(name: "scroll")
            .onAppear { model.showDetail = true } //해당 뷰가 보이도록
            .onDisappear { model.showDetail = false }
//            .background(Color("Background"))
            .background(Color.white)
            .mask(RoundedRectangle(cornerRadius: viewState.width / 3, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(isDraggable ? drag : nil)
            .ignoresSafeArea()

            button // 저기 위에 'x 버튼'
            
            // 데이터 아직 로드 안되었을 때 버튼 enable 해놓기
            // 버튼이
            // isLoading true이면 button disable  TRUE, opacity 0.5
            // isLoading false이면 button disable  FALSE (즉, 다 로드되면 opacity 1)
            
            mapButton // '지도로 보기' 버튼
                .offset(x: 10 ,y: 300)
            
        }
        .onAppear {
//            magazineVM.fetchFoodCarts(foodCartIds: magazine.foodCartId)
//            print("\()")
            print("아직 로드 전")
            isLoading = true
            
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
            
            Task {
                fadeIn()
                
                magazineVM.magazineFoodCart = try await
                magazineVM.fetchFoodCarts(foodCartIds: magazine.foodCartId)
                
                //foodcart가 채워지면서 
                print("로드 완료")
                // 스켈레톤 View를 위해
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                    isLoading = false
//                }
            }
        }
        .onDisappear {
            magazineVM.magazineFoodCart = []
            print("detail disappeared")
        }
//        .refreshable {
//            magazineVM.magazineFoodCart = try await
//            magazineVM.fetchFoodCarts(foodCartIds: magazine.foodCartId)
//
//        } //37.512483, 127.058934
        .onChange(of: show) { _ in
            fadeOut()
        }
        .sheet(isPresented: $showMap) {
//            MCardMapView(model: model)
            MagazineNaverMapView(model: model,
                                 showMap: $showMap,
                                 foodcart: magazineVM.magazineFoodCart,
                                 coord: (magazineVM.magazineFoodCart[0].geoPoint.latitude, (magazineVM.magazineFoodCart[0].geoPoint.longitude)))
        }
        
    } //body

    //MARK: - 이미지와 배경이 있는 상단 뷰
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
                Image(magazine.image) // 핸드폰 사진들
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

    
    var content: some View {
        VStack {
            ForEach(magazineVM.magazineFoodCart) { foodcart in
//                Text("\(foodcart.id)")
                MStoreCellView(foodcart: foodcart, magazineVM: magazineVM, isLoading: $isLoading, opacity: $opacity)
                    .padding(.horizontal, 3)
            }

            Spacer()
        }
    }

    //MARK: - xmark 버튼
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
    
    
    
    // isLoading true이면 button disable  TRUE, opacity 0.5
    // isLoading false이면 button disable  FALSE (즉, 다 로드되면 opacity 1)
    var mapButton: some View {
        Button {
            showMap = true
        } label: {
            Text("지도에서 보기")
                .font(.machachaTitle3Bold)
                .foregroundColor(.white)
                .padding()
                .background(
                  Capsule()
                    .fill(isLoading ? Color("Color3").opacity(0.5) : Color("Color3"))
                  )
        }
        .disabled(isLoading)
        .frame(maxWidth: .infinity,alignment: .bottomTrailing)
        .padding(30)
        .ignoresSafeArea()

    }
    
    
    //MARK: - [한입 간식: 호떡 ~ 에디터 한줄]까지의 뷰
    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(magazine.title) // SwiftUI for iOS 15
                .font(.machachaLargeTitleBold)
                .matchedGeometryEffect(id: "title\(magazine.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(magazine.subtitle) //20 sections - 3 hours
                .font(.machachaTitle3Bold)
                .matchedGeometryEffect(id: "subtitle\(magazine.id)", in: namespace)

            Divider()
                .opacity(appear[0] ? 1 : 0)
                .padding(.bottom, 3)
            
            VStack (alignment: .leading) {

                Text(magazine.editorPickTitle)
                    .font(.machachaSubheadBold)
                    .padding(.bottom, 2)
                
                Text("\"\(magazine.editorCommemt)\"")
                    .font(.machachaSubhead)
            }
            .opacity(appear[2] ? 1 : 0)
        }
        .padding(20)
        .background(
            Rectangle()
                .fill(.thinMaterial)
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
        var delay = 0.2 //원래  0.3
        for i in 0 ..< appear.count {
            withAnimation(.easeOut.delay(delay)) {
                appear[i] = true
                delay += 0.418
            }
        }
    }

    func fadeOut() {
        appear = Array(repeating: false, count: appear.count)

        
        /*
         for index in stride(from: 5, to: 1, by: -1) {
             print(index)
         }
         //p
         */
    }

    func close() {
        withAnimation(.closeCard.delay(0.3)) { //0.3
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
            model: Model(),
            magazineVM: MagazineViewModel()
        )
    }
}
