//
//  MachachaApp.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //FirebaseApp.configure()
        // 원격 알림 등록
        //UNUserNotificationCenter.current().delegate = self
        
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: { _, _ in }
//        )
        
        //application.registerForRemoteNotifications()
        // 메세징 델리게이트
        //Messaging.messaging().delegate = self
        
        // 푸시 포그라운드 설정
        //UNUserNotificationCenter.current().delegate = self
        
        
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NAVTIVE_APP_KEY"] ?? ""
        
        //print("kakaoAppKey: \(kakaoAppKey)")
        //Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        return true
    }
    // fcm 토큰이 등록 되었을 때
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
    // SceneDelegate  연결을 위한 함수
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//
//        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//
//        sceneConfiguration.delegateClass = SceneDelegate.self
//
//        return sceneConfiguration
//    }
}


@main
struct MachachaApp: App {
    init() {
        // Naver SDK Initializing
        
        // 네이버 앱으로 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
        // 브라우저 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true
        
        // 네이버 로그인 세로모드 고정
        NaverThirdPartyLoginConnection.getSharedInstance().setOnlyPortraitSupportInIphone(true)
        
        // NaverThirdPartyConstantsForApp.h에 선언한 상수 등록
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
        
        // Kakao SDK 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
                .onOpenURL { url in
                    
                    //네이버
                    if NaverThirdPartyLoginConnection
                        .getSharedInstance()
                        //임의로 아무거나 넣어봄
                        .isNaverAppOauthEnable
                    //.isInAppOauthEnable
                        //.isNaverThirdPartyLoginAppschemeURL(url)
                    {
                        // Token 발급 요청
                        NaverThirdPartyLoginConnection
                            .getSharedInstance()
                            .receiveAccessToken(url)
                    }
                    
                    //카카오
                    if (AuthApi.isKakaoTalkLoginUrl(url)){
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                    
                    // 구글
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                            // Check if `user` exists; otherwise, do something with `error`
                          }
                        }
        }
    }
}