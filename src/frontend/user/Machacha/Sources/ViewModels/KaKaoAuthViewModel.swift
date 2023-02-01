import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KaKaoAuthViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    static let shared = KaKaoAuthViewModel()
    //let userVM = UserViewModel()
    
    @MainActor
    //실제로 로그아웃을 처리하는건 여기에서 할 것
    func kakaoLogout() {
        // async/await 함수는 Task 안에서 호출해야 함
        Task {
            // async/await 함수이기 때문에 호출할 때 await
            if await handleKaKoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    
    // 클로저 방식 - async/await 방식으로 변경해보려고 함
    // 로그아웃을 처리하는 async/await 함수
    func handleKaKoLogout() async -> Bool {
        
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    // 로그아웃 성공했을 때가 true 리턴
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        // 카카오 앱을 통해 로그인
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        })

    }
    
    func handleLoginWithKaKaoAccount()async -> Bool {
        // 클로저를 await/async로 바꾸는 과정이구나~
        await withCheckedContinuation({ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")
                        
                        // 카카오 로그인 성공시 싱글톤으로 loginState 변경
                        //AuthViewModel.shared.loginState = .authenticated
                        //do something
                        guard let token = oauthToken else { return }
                        
                        UserDefaults.standard.set(token.accessToken, forKey: "userIdToken")
                        //self.userVM.addUser(User(id: token.accessToken, name: "철수", email: "", phoneNumber: "", image: "", myRegisterStore: [], myReview: [], bookmark: [], isAlert: false))
                            //AuthViewModel.shared.state = .signIn
                        
                        continuation.resume(returning: true)
                    }
                }
        })
    }
    
    @MainActor // 메인 스레드에서 동작하게끔 해준다
    func handleKaKaoLogin() {
        Task {
            // 카카오톡 실행 가능 여부 확인 - 설치 되어있을 때
            if (UserApi.isKakaoTalkLoginAvailable()) {
                //카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
                
                

            } else { // 설치 안되어 있을 때
                // 카카오 웹뷰로 로그인
                isLoggedIn = await handleLoginWithKaKaoAccount()
            }
        }
    }
}
