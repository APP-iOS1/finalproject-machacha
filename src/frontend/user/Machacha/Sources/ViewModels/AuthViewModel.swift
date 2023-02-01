//
//  AuthViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth

//enum LoginState {
//    case authenticated
//    case unauthenticated
//    case authenticating
//    case pass
//}

@MainActor
class AuthViewModel : ObservableObject {
    @Published var loginState : LoginState? = nil
    let userVM : UserViewModel = UserViewModel()
    
    //static let shared = AuthViewModel()
    
    @Published var currentUserProfile: User? = nil
    @Published var showError: Bool = false
    @Published var currentUser = Auth.auth().currentUser
    @Published var userCheck : UserCheck = .checking
    
    // MARK: - google Sign in Properties
    //@Published var givenName: String = ""
    //@Published var profilePicUrl: String = ""
    //@Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: Apple Sign in Properties
    @Published var nonce: String = ""
    
    
    // MARK: - UserProfile 유무 판별함수
    /// 로그인 후, 해당 유저의 프로필이 등록되어있는지 확인하는 함수
    func fetchUserInfo(_ userId: String) async throws -> User? {
        guard (Auth.auth().currentUser != nil) else { return nil}
        let ref = Firestore.firestore().collection("User").document(userId)
        let snapshot = try await ref.getDocument()
        guard let docData = snapshot.data() else { return nil }
        let name = docData["name"] as? String ?? ""
        let email = docData["email"] as? String ?? ""
        let isFirstLogin = docData["isFirstLogin"] as? Bool ?? true
        
        let user = User(id: snapshot.documentID, isFirstLogin: isFirstLogin, email: email, name: name, profileId: "", favoriteId: [], visitedId: [], updatedAt: Date(), createdAt: Date())
        return user
    }
    
    
    
    func signout(){
        do{
            try Auth.auth().signOut()
            withAnimation(.easeInOut){self.loginState = .unauthenticated}
            self.currentUserProfile = nil
            currentUser = nil
            
        }catch{
            print("실패")
        }
        
    }
    
    // MARK: Handling Error
    func handleError(error: Error) async {
        
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    // MARK: Apple Sign in API
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) async {
        // getting Token...
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        // Token String...
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        do {
            let authResult = try await FirebaseAuth.Auth.auth().signIn(with: firebaseCredential)
            self.currentUserProfile =  try await fetchUserInfo(authResult.user.uid)
            self.currentUser = authResult.user
            withAnimation(.easeInOut){self.loginState = .authenticated}
        }catch{
            print("appleLogin Fail..!")
        }
        
    }
    
    // MARK: Logging Google User into Firebase
    func googleSignIn() {
        // 한번 로그인한 적이 있음(previous Sign-In ?)
                if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                    // 있으면 복원 (yes then restore)
                    GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                        authenticateUser(for: user, with: error)
                        
                    }
                } else {// 처음 로그인
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                    
                    // 3
                    let configuration = GIDConfiguration(clientID: clientID)
                    
                    // 4 .first 맨 위에 뜨게 하도록
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
                    
                    // 5
                    //signIn( )그런 다음 클래스 의 공유 인스턴스에서 호출 GIDSignIn하여 로그인 프로세스를 시작합니다. 구성 개체와 표시 컨트롤러를 전달합니다
                    
                    //             GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                    //                 authenticateUser(for: user, with: error)
                    //             }
                    
                    GIDSignIn.sharedInstance.configuration = configuration
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                        guard let user = result?.user else { return }
                        authenticateUser(for: user, with: error)
                        
                    }
                    
                }
    }
    
    
    // MARK: - [카카오 Auth]
    func kakaoLogout() async {
        UserApi.shared.logout {(error) in
            if let error{
                print("error: \(error)")
            }
            else {
                print("== 로그아웃 성공 ==")
                try? Auth.auth().signOut()
            }
        }
    }
    
    func kakaoLoginWithApp() async {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                //do something
                self.loginState = .authenticated
                //_ = oauthToken
                if let oauthToken = oauthToken {
                    print("DEBUG: 카카오톡 \(oauthToken)")
                    self.signUpKaKaoInFirebase()
                }
            }
        }
    }
    
    // MARK: - 카카오 계정으로 로그인
    func kakaoLoginWithWeb() async {
        UserApi.shared.loginWithKakaoAccount {(token, error) in
            if let error = error {
                print(error)
            }
            else {
                print("웹 로그인 성공")
                if let token {
                    print("\(token)")
                    self.signUpKaKaoInFirebase()
                }
            }
        }
    }
    
    func kakaoLogin() {
        Task{
            if (UserApi.isKakaoTalkLoginAvailable()) {
                await kakaoLoginWithApp()
            } else {
                await kakaoLoginWithWeb()
                //await UserViewModel.shared.requestUserCheck()
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool{
        await withCheckedContinuation({ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        })
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            // 1
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // 2 user 인스턴스에서 idToken 과 accessToken을 받아온다
            // 인증
            /* 원래
             guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
             
             let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
             */
            
            guard let accessToken = user?.accessToken, let idToken = user?.idToken else {return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // 3
        FirebaseAuth.Auth.auth().signIn(with: credential) { [unowned self] (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    UserDefaults.standard.set(result?.user.uid, forKey: "userIdToken")
                    withAnimation(.easeInOut){self.loginState = .authenticated}
                    UserViewModel.shared.requestUserCheck()
                }
            }
        }
    
    func signUpKaKaoInFirebase() {
        UserApi.shared.me() { user, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                // 파이어베이스 유저 생성
                print("카카오계정 생성중")
                Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))") { result, error in
                    Task{
                        if let error {
                            print(error)
                        }
                        let authResult = try await Auth.auth().signIn(withEmail: (user?.kakaoAccount?.email ?? "")!, password: "\(String(describing: user?.id))")
                        self.currentUserProfile = try await self.fetchUserInfo(_: authResult.user.uid)
                        self.currentUser = authResult.user
                        withAnimation(.easeInOut){self.loginState = .authenticated}
                        UserViewModel.shared.requestUserCheck()
                    }
                }
            }
        }
    }
}

//카카오 플랫폼 안에서 앱과 사용자 카카오계정의 연결 상태를 해제합니다. UserApi의 unlink()를 호출합니다.
//연결이 끊어지면 기존의 토큰은 더 이상 사용할 수 없으므로, 연결 끊기 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰이 삭제됩니다.
func unlinkKakao(){
    UserApi.shared.unlink {(error) in
        if let error = error {
            print(error)
        }
        else {
            print("unlink() success.")
        }
    }
}

// 로그인후 유저 정보 입력
func inputUserInfo() {
    UserApi.shared.me() { user, error in
        if let error = error {
            print("유저 정보 에러 :\(error)")
        }
    }
}


// MARK: Extensions
extension UIApplication {
    func rootController() -> UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene else {return .init()}
        guard let viewcontroller = window.windows.last?.rootViewController else {return .init()}
        
        return viewcontroller
    }
}

// MARK: Apple Sign in Helpers
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}
