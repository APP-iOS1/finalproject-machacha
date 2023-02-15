//
//  FCMTokenViewModel.swift
//  Machacha
//
//  Created by MacBook on 2023/02/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// 알림에 사용할 디바이스 토큰 과 유저ID를 관리할 ViewModel
class FCMTokenViewModel {
    static let shared = FCMTokenViewModel()
    
    var fcmToken: String?
    
    let db = Firestore.firestore()
    
    func addToken() {
        guard let user = Auth.auth().currentUser else {
            print("FCMTokenViewModel: addToken 실패 (currentUser 없음)")
            return
        }
        
        guard let fcmToken else {
            print("FCMTokenViewModel: addToken 실패 (fcmToken 없음)")
            return
        }
        
        db.collection("FCMToken")
            .document(user.uid)
            .setData(["userId": user.uid,
                      "fcmToken": fcmToken
                     ])
    }
    
}
