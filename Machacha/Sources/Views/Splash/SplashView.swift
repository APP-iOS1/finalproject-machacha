//
//  SplashView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimation:Bool = false
    @State private var rotation = 100.0
    
    var body: some View {
        ZStack {
            
            
            
            Image("tteokboki")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 1.2)
                .offset(x: -32, y: rotation )
            
            
            Image("sweetpotato")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.7)
                .offset(x: -14, y: rotation - 50 )
            
            
            Image("fishcake")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.66)
                .offset(x: 90, y: rotation - 45)
            
            Image("bbungbread")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.5)
                .rotationEffect(Angle(degrees: 100))
                .offset(x: 58, y: rotation - 10)
            
            Image("store")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 1.4)
                .padding(.leading, Screen.maxWidth * 0.06)
                .offset(y: -100)
            // 손글씨
            // 폰트
            
            if isAnimation {
                
                Text("마차챠")
                    .font(.custom("나눔손글씨 느릿느릿체", size: 100))
                    .bold()
                    .offset(y: 100)
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
