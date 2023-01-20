//
//  AuthViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import Foundation

//enum LoginState {
//    case authenticated
//    case unauthenticated
//    case authenticating
//    case pass
//}

class AuthViewModel : ObservableObject {
    @Published var loginState : LoginState? = nil
    
    static let shared = AuthViewModel()
    
    
}
