//
//  MagazineView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
/*
 ForEach(magazineVM.magazines) { magazine in }
 
 .onAppear {
 magazineVM.fetchMagazines()
 
 }
 
 */
//

struct MagazineView: View {
    @Namespace var namespace // @Namespace : 관련있는 것들끼리 모아놓은 공간
    @State var show = false
    @State var showStatusBar = true
    
    @State var selectedID = ""
    @State var showCourse = false
    @State var selectedIndex = 0
    
    @StateObject var model: Model = Model()
    @StateObject var magazineVM = MagazineViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 라이트: 흰색, 다크: 검정 배경
                // Assets에 Colors 폴더 "Background" 확인
                Color("bgColor")
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    
                    Text("Courses".uppercased())
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    // 내가 봐야할 곳
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                        if !show {
                            cards //컨텐츠들
                        } else {
                            // 카드를 선택했을 경우 카드가 나열된 화면 대신 Rectangle이 보이도록
                            ForEach(magazineVM.magazines) { _ in
                                Rectangle()
                                    .fill(.white)
                                    .frame(height: 300)
                                    .cornerRadius(30)
                                    .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                                    .opacity(0.3)
                                    .padding(.horizontal, 30)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                // coordinateSpace?
                // 특정 뷰의 좌표 공간 - scrollDetection
                .coordinateSpace(name: "scroll")
                .navigationTitle("마차챠's PICK")
                .navigationBarHidden(show ? true : false)
                .toolbar { // 딱히 필요없는 것 같지만 일단은 가지고 가겠음
                    //                NavigationBar()
                    
                }
                // 내가 봐야할 부분
                if show {
                    detail
                }
                
            }.statusBar(hidden:!showStatusBar)
                .onChange(of: show) { newValue in
                    withAnimation(.closeCard) {
                        if newValue {
                            showStatusBar = false
                        } else {
                            showStatusBar = true
                        }
                    }
                }
        }//navigationview
        .onAppear {
            magazineVM.fetchMagazines()
            
        }
    }//body
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
    }
    
    
    
    // 내가 봐야할 부분
    var cards: some View {
        ForEach(magazineVM.magazines) { magazine in
            // CourseItem 각각의 카드들
            // course : 각각의 Course()
            MCardView(namespace: namespace, magazine: magazine , show: $show)
                .onTapGesture {
                    withAnimation(.openCard) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedID = magazine.id // 사용자가 선택한 카드를 구별하기 위해 selectedID
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isButton)
        }
    }
    // 내가 봐야할 부분
    var detail: some View {
        ForEach(magazineVM.magazines) { magazine in
            if magazine.id == selectedID {
                // CourseItem 펼친 view
                // model도 넘겨주자
                MCardDetailView(namespace: namespace, magazine: magazine, show: $show, model: model)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                        removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                    ))
            }
        }
    }
    
}

struct MagazineView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineView()
    }
}
