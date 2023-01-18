//
//  SplashView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct SplashView: View {
    func test() {
        for family: String in UIFont.familyNames {
            print(family)
            for names : String in UIFont.fontNames(forFamilyName: family){
                print("=== (names)")
            }
        }
    }
    var body: some View {
        ZStack {
            
            
            
            Image("tteokboki")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 1.2)
                .offset(x: -32, y: 40 )
            
            
            Image("sweetpotato")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.7)
                .offset(x: -14, y: -10 )
            
            
            Image("fishcake")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.66)
                .offset(x: 90)
            
            Image("bbungbread")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 0.5)
                .rotationEffect(Angle(degrees: 100))
                .offset(x: 58, y: 15)
            
            
            Image("store")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Screen.maxWidth * 1.4)
                .padding(.leading, Screen.maxWidth * 0.06)
                .offset(y: -100)
            // 손글씨
            // 폰트
            Text("마차챠")
                .font(.custom("나눔손글씨 백의의 천사", size: 80))
                .bold()
                .offset(y: 100)
            
            Button {
                test()
            } label: {
                Text("Test")
                    .font(.largeTitle)
            }
            .offset(y: 200)
            
            
            
        }
        .listStyle(.automatic)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
