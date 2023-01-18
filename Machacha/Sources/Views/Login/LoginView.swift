//
//  LoginView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NaverThirdPartyLogin
import GoogleSignInSwift
import GoogleSignIn

enum LoginState {
    case authenticated
    case unauthenticated
    case authenticating
    case pass
}

struct AuthView : View {
    @State var loginState : LoginState = .unauthenticated
    
    var body: some View {
        switch loginState {
        case .unauthenticated :
            LoginView(loginState: $loginState)
        case .authenticating :
            ProgressView()
        case .authenticated, .pass:
            ContentView()
        }
    }
}


struct LoginView: View {
    @Binding var loginState : LoginState
    @StateObject var kakaoAuthVM = KaKaoAuthViewModel()
    @StateObject var googleAuthVM = GoogleAuthModel()
    var viewModel = NaverLoginViewModel()
    var body: some View{
        VStack{
            
            //네이버 로그인 버튼
            Button {
                if NaverThirdPartyLoginConnection
                    .getSharedInstance()
                    .isPossibleToOpenNaverApp() // Naver App이 깔려있는지 확인하는 함수
                {
                    NaverThirdPartyLoginConnection.getSharedInstance().delegate = viewModel.self
                    NaverThirdPartyLoginConnection
                        .getSharedInstance()
                        .requestThirdPartyLogin()
                } else { // 네이버 앱 안깔려져 있을때
                    // Appstore에서 네이버앱 열기
                    NaverThirdPartyLoginConnection.getSharedInstance().openAppStoreForNaverApp()
                    
                }
            } label : {
                Image("naver_login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320,height: 80)
            }.padding(20)
            
            //카카오 로그인 버튼
            Button {
                kakaoAuthVM.handleKaKaoLogin()
            } label: {
                Image("kakaologin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320,height: 80)
            }.padding(20)
            
            //구글 로그인 버튼
            GoogleSignInButton(action: googleAuthVM.signIn)
            
            Button {
                loginState = .pass
            } label: {
                Text("건너뛰기")
                    .frame(width: 320,height: 80)
            }.padding(20)
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
