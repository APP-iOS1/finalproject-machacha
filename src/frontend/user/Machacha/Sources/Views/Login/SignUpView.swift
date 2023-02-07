//
//  SignUpView.swift
//  Machacha
//
//  Created by MacBook on 2023/01/31.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var userVM : UserViewModel
    
    @State private var name : String = ""
    
    var body: some View {
        VStack{
            TextField("이름을 입력해주세요", text: $name)
            Button(action: {
                let result = userVM.firstLogin(name)
                if result { withAnimation(.easeInOut){userVM.userCheck = .correct} }
                
            }) {
                Text("등록")
            }
        }
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
