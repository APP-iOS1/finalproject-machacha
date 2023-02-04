//
//  SnapCarousel.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    //Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    @Binding var coord: (Double, Double)
    init(spacing: CGFloat = 30, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], coord: Binding<(Double, Double)>, @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
        self._coord = coord
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            // Setting correct Width for snap Carousel
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: abs(proxy.size.width - trailingSpace))
                }
            }
            // Spacing will be horizontal padding
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(index) * -width) + (index != 0 ? adjustMentWidth : 0) + offset)
            .animation(.easeInOut)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded( { value in
                        // 인덱스 이동
                        let offsetX = value.translation.width
                        // 0~1의 값으로 변환 후 인덱스에 +1 or -1을 해줌
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        // 최대크기 만큼 페이징을 위해 계산
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                        
                        if let points = list as? [FoodCart] {
                            coord = (points[index].geoPoint.latitude, points[index].geoPoint.longitude)
                        }
                        
                        print("carousel index : \(index)")
                    })
                    .onChanged( { value in
                        // updating only index
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        // Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchView()
    }
}
