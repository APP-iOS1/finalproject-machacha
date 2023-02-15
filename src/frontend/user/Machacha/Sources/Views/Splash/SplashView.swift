//
//  SplashView.swift
//  Machacha
//
//  Created by Sue on 2023/02/15.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimation:Bool = false
    @State private var rotation = 100.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Image("tteokboki2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.35)
                        .offset(x: 36, y: rotation )
                    
                    
                    
                    Image("sweetpotato2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.354)
                        .offset(x: -geometry.size.width * 0.12, y: rotation ) //70
                    
                    
                    Image("fishcake2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.35)
                        .offset(x: -geometry.size.width * 0.34, y: rotation - 3)
                    
                    Image("bbungbread2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.31)
                        .rotationEffect(Angle(degrees: 100))
                        .offset(x: -geometry.size.width * 0.55, y: rotation - 7)
                }
                .offset(y: geometry.size.height * 0.16)

                Image("store2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.9)
//                    .padding(.leading, Screen.maxWidth * 0.06)
                    .offset(x: -geometry.size.width * 0.22, y: geometry.size.height * 0.17 )
                
                
                if isAnimation {
                    
                    Text("마차챠")
                        .font(.custom("나눔손글씨 느릿느릿체", size: 97))
                        .bold()
                        .offset(x:  -geometry.size.width * 0.2 ,y: geometry.size.height * 0.312)
                }
            }
            
        }
        .background {
            Color("cellColor")
        }
        .animation(.easeIn(duration: 1.5), value: rotation)
        .onAppear {
            rotation = 40
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isAnimation = true
                    rotation = 40
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
