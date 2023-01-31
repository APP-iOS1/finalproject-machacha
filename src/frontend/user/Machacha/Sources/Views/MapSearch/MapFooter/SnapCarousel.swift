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
    
    
    init(spacing: CGFloat = 0, trailingSpace: CGFloat = 70,  items: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self.content = content
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
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            // Spacing will be horizontal padding
            .padding(.horizontal, spacing)
            // setting only after 0th index
            .offset(x: (CGFloat(currentIndex) * -width) + adjustMentWidth + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded( { value in
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value
                        // based on the prgoress increasing or decreasing the currentIndex
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        // setting min
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        print("current index : \(currentIndex)")
                    })
                    .onChanged( { value in
                        // updating only index
                        // Updating Current Index
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value
                        // based on the prgoress increasing or decreasing the currentIndex
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        // setting min
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
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
