//
//  AuthView.swift
//  Machacha
//
//  Created by MacBook on 2023/01/31.
//

import Foundation
import SwiftUI
import NaverThirdPartyLogin
import GoogleSignInSwift
import GoogleSignIn
import _AuthenticationServices_SwiftUI

enum LoginState {
    case authenticated
    case unauthenticated
    case authenticating
    case pass
}

struct AuthView : View {
    //@State var loginState : LoginState = .unauthenticated
    @EnvironmentObject var authVM : AuthViewModel//.shared
    @StateObject var userVM = UserViewModel.shared
    
    var body: some View {
        switch authVM.loginState {
        case .unauthenticated, .none :
            LoginView()
                .environmentObject(authVM)
        case .authenticating :
            ProgressView()
        case .authenticated :
            switch userVM.userCheck {
            case .checking :
                ProgressView()
            case .incorrect :
                LoginView()
                    .environmentObject(authVM)
            case .correct :
                ContentView()
            case .firstLogin :
                SignUpView()
                    .environmentObject(authVM)
                    .environmentObject(userVM)
            }
        case .pass:
            ContentView()
                .onAppear{
                    print(authVM.loginState!)
                }
        }
    }
}
