import NaverThirdPartyLogin
import Alamofire
import Combine

class NaverLoginViewModel : NSObject, ObservableObject {
    @Published var state : Bool = false
    
    
}

extension NaverLoginViewModel : UIApplicationDelegate, NaverThirdPartyLoginConnectionDelegate {
    // 토큰 발급 성공시
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰 요청 완료")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그인 토큰이 삭제되었습니다.")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        //print("error: \(error)")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        
        self.getNaverUserInfo(loginInstance.tokenType, loginInstance.accessToken)
    }
    
    func startNaverLogin() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else { return }
        
        //이미 로그인되어있는 경우
        if loginInstance.isValidAccessTokenExpireTimeNow() {
            self.getNaverUserInfo(loginInstance.tokenType, loginInstance.accessToken)
            return
        }
        
        loginInstance.delegate = self
        loginInstance.requestThirdPartyLogin()
    }
    
    func getNaverUserInfo( _ tokenType : String?, _ accessToken : String?) {
        
        guard let tokenType = tokenType else { return }
        guard let accessToken = accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        // let req =
        _ = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
//        req.responseJSON { [weak self] response in
//            let decoder = JSONDecoder()
//            
//            print("response: ",response)
//        }
    }
}
