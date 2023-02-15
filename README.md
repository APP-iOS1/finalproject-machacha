# 🍢 마차챠
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Swift](https://img.shields.io/badge/SwiftUI-0052CC?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![KakaoTalk](https://img.shields.io/badge/kakaotalk-ffcd00.svg?style=for-the-badge&logo=kakaotalk&logoColor=000000)
![Naver](https://img.shields.io/badge/Naver-00C300?style=for-the-badge&logo=naver&logoColor=white)

## ⚖️ 앱 정의(ADS)
### 앱의 소개

```
마차챠는 포장마차의 위치 및 영업 시간을 정확히 알고 싶은 사람들을 위한 앱이다.
```
### **ADS**

```
포장마차 이용하는 사람들
```

### **페르소나**

```
마차챠는 포장마차의 위치 및 영업 시간을 정확히 알고 싶은 사람들을 위한 앱이다.
```

### **프로젝트 필요성**

```
- 포장마차 관련 정보들(위치, 결제 수단, 기록 등)을 알려주기 위한 '사용자 니즈'를 파악하고 앱으로 구현하고자 한다.
```

## 👨‍👩‍👧‍👦 참여자
<div align="center">
  <table style="font-weight : bold">
      <tr align="center">
          <td colspan="5"> 팀 목표 : </td>
      </tr>
      <tr>
          <td align="center">
              <a href="https://github.com/GeonHyeongKim">                 
                  <img alt="김건형" src="https://avatars.githubusercontent.com/GeonHyeongKim" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/suekim999">                 
                  <img alt="김수현" src="https://avatars.githubusercontent.com/suekim999" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/jwoo820">                 
                  <img alt="박정우" src="https://avatars.githubusercontent.com/jwoo820" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/jeoneeee">                 
                  <img alt="이지연" src="https://avatars.githubusercontent.com/jeoneeee" width="80" />            
              </a>
          </td>
          <td align="center">
              <a href="https://github.com/Heodoo">                 
                  <img alt="허두영" src="https://avatars.githubusercontent.com/Heodoo" width="80" />            
              </a>
          </td>
      </tr>
      <tr>
          <td align="center">신기술을 사용할래요</td>
          <td align="center">UIKit, 이미지 캐싱</td>
          <td align="center">UIKit, 의존성 주입</td>
          <td align="center">Clean Code, 팀원 코드</td>
          <td align="center">UIKit, 실시간, 알림</td>
      </tr>
      <tr>
          <td align="center">김건형</td>
          <td align="center">김수현</td>
          <td align="center">박정우</td>
          <td align="center">이지연</td>
          <td align="center">허두영</td>
      </tr>
  </table>
</div>

## 📱 주요기능과 스크린샷

- 최종프로젝트에서는 **명동, 을지로**의 정보만 다룰 예정이다.
- 젊은층을 Target
- 네이버 Map SDK를 사용할 예정이다.
- FireBase + Combine를 통해 Network 통신을 할 예정이다.

<details>
<summary>1. Tab1(Home)</summary>
<div markdown="1">
  
```
- 추천 (지역기반 - 사용자 필터 평점, 추천알고리즘 구현)
- 마차챠가 추천하는 (계절, 시즌)
- ’마챠킹’님을 위한 (2번째 Tab 검색어 기준)
- 2000원으로 갈수 있는곳
- 지역 (최근에 등록된 포장마차가 1건있다. 확인해주세요)
```
  
</div>
</details>
<details>
<summary>2. Tab2(검색)</summary>
<div markdown="2">
    
```
- '음식 이름(메뉴)'를 검색
- Map 에서 포장마차의 pin(marker)로 알려주기
- Map 필터 기능(거리순, 리뷰순, 평점순)
- Marker를 Click하면, Modal을 통한 Detail 가게 정보
- 길찾기 기능
- 로드뷰 (포장마차를 찾기 위해서)
- 현위치에서 재검색
- 서비스 불가 지역 표시하기
- 현재위치 표시/돌아가기
- 음성으로 찾기
- 즐겨찾기
- Custom Marker를 제공(붕어빵, 고구마 등)
- 이미지 클러스터링
- 키워드로 분류하여 보기 (전체, 붕어빵, 고구마, 떡볶이, 닭꼬치, 타코야끼, 호떡, 핫도그, 계란빵, 옥수수, 오뎅, 와플, 토스트, 땅콩빵, 닭강정, 기타, 호두/땅콩, 마시멜로우 … 등)
```
  
</div>
</details>
<details>
<summary>3. Tab3(등록)</summary>
<div markdown="3">
    
```
- progress bar(1→2→3→4) 제공
- 포장마차 등록 → 위치(map으로 pin을 꽃아서)를 찾기 → 상세정보(출몰시기, 메뉴, 의자 유무, 결제 수단, 영업시간…등) → 등록 완료!
- OpenCV 메뉴판을 찍으면 메뉴를 OCR (지뢰)
- 소리(진동)
```
  
</div>
</details>
<details>
<summary>4. Tab4(매거진)</summary>
<div markdown="4">
    
```
- 10,000원으로 길을 추천 (길찾기 기능) - 운영자가 직접 추천
- 빵동여지도 참고!(표현되어야하는것들: 이미지들, title, Description, 좌표들(루트보기), 좋아요, 핫키워드(재방문을 멈출수 없는, 만원으로 즐기는)
- 쇼츠로도 표현하면 좋을듯
- 가게 정보를 영상으로
```
  
</div>
</details>
<details>
<summary>5. Tab5(프로필)</summary>
<div markdown="5">
    
```
- 즐겨찾기
- 리뷰관리
- 등록한곳
- 프로필수정(닉네임, 비밀번호)
- 로그아웃/회원탈퇴    - 개인정보 방침 & 라이센스 & 사용한 오픈소스
- 가봤어요
- 공지사항
- 문의하기
- 알림
- FaceID
- 언어설정(다국어)
- 다크모드
- 보안쪽 정보
```
  
</div>
</details>
<details>
<summary>6. Detail(Map, Home, 메거진에서 연결</summary>
<div markdown="6">
    
```
- 사진 (5개 중 여러개, 더보기를 통해)
- 정보 (가게이름, 주소, 좌표, 가봤어요, 자기가 찜한곳, 출몰날짜, map, 결제 수단, 메뉴, 리뷰갯수, 좋아요, 의자여부,  등)
- 신고기능 : 3번 (가봤어요, 룰을 정하자) → 정보 수정 요청, 사라진 곳을 신고, 사장님쫌…, 중복
- 리뷰 목록(1~2개, 더보기 제공) → 담당자 판단
```
  
</div>
</details>
<details>
<summary>7. 로그인</summary>
<div markdown="7">
    
```
- 네이버, 구글, 카카오 + 틱톡, 애플
```
  
</div>
</details>
<details>
<summary>8. Splash</summary>
<div markdown="8">
    
```
- Lottie
```
  
</div>
</details>
<details>
<summary>9. 알림/Push 서버</summary>
<div markdown="9">
    
```
- 전체나 알림 → 개발자 계정
- Push 서버(node.js)가 필요하다.
- 내가 즐겨찾기한 가게가 사라질때 알림(살려야합니다. 인증)
```
  
</div>
</details><details>
<summary>10. ETC.</summary>
<div markdown="10">
    
```
- 스케레톤뷰
- 모든 기기 대응(frame)
- infinite scroll (paging)
- refresh
- 다크고려
```
  
</div>
</details>
<br>

## 📚 실행 가이드 및 설치 방법
### 설치/실행 방법
* ❗️❗️아래 2가지 파일은 필수 파일임으로 파일을 요청해주세요.
```
- Config.xcconfig           // KaKaoSDK 
- GoogleService-Info.plist  // Google, FireBase
```

<br>
<details>
<summary>1. 카카오톡 로그인을 위한 사전작업</summary>
<div markdown="1">

- **config** 파일을 **Tteokbokking** 폴더에 추가한다.
    - config.xcconfig 파일 안에는 KAKAO_NAVTIVE_APP_KEY // 네이티브 앱 키가 들어있다.
    
<br>
    
- **info** 파일에 **Information Property List**에 하단의 내용들이 잘 들어가 있는지 확인
    - LSApplicationQueriesSchemes 에 item 0, item1에 각각 kakaokompassauth, kakaolink 넣기
    - KAKAO_NAVTIVE_APP_KEY에 ${KAKAO_NAVTIVE_APP_KEY}를 넣기
    - App Transport Security Settings에 Allow Arbitrary Loads 가 NO라고 되어있는지 확인
    <img src="https://user-images.githubusercontent.com/105197393/208856526-a1bd28d3-799f-45be-816c-5ac217448187.png">

<br>

- <img src = "https://user-images.githubusercontent.com/105197393/208857521-1d9f5cce-64c6-4903-953e-0da5e36efb5a.png" width="20"> **Tteokbokking**
    - PROJECT의 Info
        - Configurations의 각각 Debug, Release 안에 있는 2개의 파일 모두 Config로 설정
            <img src = "https://user-images.githubusercontent.com/105197393/208858999-fdd802ae-944d-4a31-bb27-fc8e3b422575.png">
        
    - TARGETS의 Info
        - URL Types을 펼쳐 URL Schemes에 kakao{KAKAO_NAVTIVE_APP_KEY} 가 들어있는지 확인
        <img src = "https://user-images.githubusercontent.com/105197393/208859404-ce950c84-3293-487f-a64d-8bdca02be8bc.png">
<br> 

</div>
</details>

<details>
<summary>2. 구글 로그인을 위한 사전 작업</summary>
<div markdown="1">

- **GoogleService-Info.plist**를 프로젝트에 추가
    <img src = "https://user-images.githubusercontent.com/105197393/208861493-7931c43a-da9e-4410-83db-78eb3c3d24dd.png">
    - plist 추가 후 REVERSED_CLIENT_ID의 값을 복사
<br>

- <img src = "https://user-images.githubusercontent.com/105197393/208857521-1d9f5cce-64c6-4903-953e-0da5e36efb5a.png" width="20"> **Tteokbokking**
    - TARGETS의 Info
        - URL Types를 펼쳐 URL Schemes에 **REVERSED_CLIENT_ID**이 들어 있는지 확인
</div>
</details>

<details>
<summary>⚙️ 개발 환경</summary>
<div markdown="1">

- iOS 16.0 이상
- iPhone 14 Pro에서 최적화됨
- 가로모드 미지원, 다크모드 미지원

</div>
</details>

<details>
<summary>⚒️ 활용한 기술</summary>
<div markdown="1">

- JSON/ mocki.io // Mock API 제작 서비스
- FireStore
- FireBaseAuth
- GoogleSignIn
- KakaoOpenSDK
- MapKit
- FCM / APNs

</div>
</details>
<br>

## 🤝 규칙
<details>
<summary>규칙 10가지</summary>
<div markdown="1">

```
1. 존중, 배려(존대), 재미
2. 9-6시 개발하고 야근 지양하기
3. 매일 데일리 스크럼 진행 (am 10:00 ~ am 10:15 15분간)
    ◦ 특강이 있을 경우, 끝난 다음 정각부터 시작
    ◦ 보이스 및 화상 의무
    ◦ 요일마다 돌아가면서 진행하기
4. PR은 'pm 5:00'과 'am 2:00'에 각자 올리기
    ◦ Reviewer는 팀원 전부(GeonHyeongKim, suekim999, jwoo820, jeoneeee, Heodoo)
    ◦ Merge는 2번째 사람이 Merge 해주기
5. 개발도 중요하지만, 기록도 생각하기
    ◦ Project 카반보드 활용 
7. '아!’ & ‘어?’ 참아보기
8. 막힐때, @맨션을 걸어서 Pair 코딩하기
9. 세미나(발표) - 자유주제(요청)
    ◦ 목(pm 10시)
    ◦ 5~10분 (max 15분)
10. 실제로 오프라인으로 같이 개발하기
```

</div>
</details>

<details>
<summary>코드 컨벤션</summary>
<div markdown="1">

- feat/이슈번호-큰기능명/세부기능명
```
- [Feat] 새로운 기능 구현
- [Chore] 코드 수정, 내부 파일 수정, 주석
- [Add] Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 파일 생성 시, 에셋 추가
- [Fix] 버그, 오류 해결
- [Del] 쓸모없는 코드 삭제
- [Move] 파일 이름/위치 변경
```

</div>
</details>

<details>
<summary>깃 브렌치</summary>
<div markdown="2">

- feat/이슈번호-큰기능명/세부기능명
```
예시)
feat/13-tab1/map
feat/13-tab1/search
feat/26-tab2/recipe
```

</div>
</details>

<details>
<summary>폴더링 컨벤션</summary>
<div markdown="3">

```
📦 Machacha
| 
+ 🗂 Configuration
|         
+------🗂 Constants   // 기기의 제약사항: width, height를 struct로 관리
│         
+------🗂 Extensions  // extension 모음
│         
+------🗂 Fonts       // 폰트 모음: 무료 폰트인 Pretendard 사용
|
+------🗂 Modifiers   // modifier 모음
│         
+ 🗂 Sources
|
+------🗂 Models      // Json을 받기 위한 Hashable, Codable, Identifiable 프로토콜을 체택한 struct 관리
│         
+------🗂 Network     // ObservableObject을 체택하여 네트워크 관리
|
+------🗂 Views       // 여러 View를 모음
        |
        +------🗂 Welcome       // SignIn / SignUp
        |
        +------🗂 Splash        // Splash View
        │         
        +------🗂 Home          // Tab 1
        |
        +------🗂 Search        // Tab 2
        |
        +------🗂 Register(+)   // Tab 3
        │         
        +------🗂 Bookmark      // Tab 4
        |
        +------🗂 Profile       // Tab 5
        |
        +------🗂 Detail        // Tab 1, 2, 4 -> 가게 상세 View
        │         
        +------🗂 Map           // MapView
        |
        +------🗂 ETC.          // 여분의 View: CustomTabView, TextButtonClearButton 등
```
</div>
</details>
<br>

## 👣 후기
- 김건형 : 
- 김수현 : 
- 박정우 : 
- 이지연 : 
- 허두영 : 
<br>

## 📄 Docs
<details>
<summary> 문서정리 </summary>
<div markdown="1">

https://github.com/APPSCHOOL1-REPO/finalproject-machacha/tree/main/docs

</div>
</details>


## 라이센스
Machacha is available under the MIT license. See the LICENSE file for more info.
