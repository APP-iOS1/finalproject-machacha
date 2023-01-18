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
    //@State var loginState : LoginState = .unauthenticated
    @StateObject var authVM = AuthViewModel.shared
    var body: some View {
        switch authVM.loginState {
        case .unauthenticated, .none :
            LoginView()
                .environmentObject(authVM)
        case .authenticating :
            ProgressView()
        case .authenticated, .pass:
            ContentView()
                .onAppear{
                    print(authVM.loginState)
                }
        }
    }
}


struct LoginView: View {
    @EnvironmentObject var authVM : AuthViewModel
    @StateObject var kakaoAuthVM = KaKaoAuthViewModel()
    @StateObject var googleAuthVM = GoogleAuthModel()
    var naverAuthVM = NaverLoginViewModel()
    var body: some View{
        ZStack{
            Color.init("bgColor")
                .ignoresSafeArea()
            VStack{
                Image("machachalogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 340)
                    .padding(.bottom,40)
                
                VStack(spacing: 18) {
                    //네이버 로그인 버튼
                    Button {
                        if NaverThirdPartyLoginConnection
                            .getSharedInstance()
                            .isPossibleToOpenNaverApp() // Naver App이 깔려있는지 확인하는 함수
                        {
                            NaverThirdPartyLoginConnection.getSharedInstance().delegate = naverAuthVM.self
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
                            .frame(width: 320)
                    }
                    
                    //카카오 로그인 버튼
                    Button {
                        kakaoAuthVM.handleKaKaoLogin()
                    } label: {
                        Image("kakaologin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 320)
                    }
                    
                    //구글 로그인 버튼
                    //GoogleSignInButton(action: googleAuthVM.signIn)
                    Button {
                        googleAuthVM.signIn()
                    } label: {
                        Image("googlelogin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 320)
                    }
                    
                    Button {
                        authVM.loginState = .pass
                    } label: {
                        Text("로그인 건너뛰기")
                            .foregroundColor(.secondary)
                            .font(.machachaHeadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
