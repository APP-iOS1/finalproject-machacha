### 🥘 오늘의 기분

- 건형: 푹잤다
- 수현: 어제 조금 야근해서 피곤하다
- 정우: 굿굿 ㅋㅋㅋㅋㅋ
- 지연: 야근.. 졸린상태
- 두영: 해장이 필요함

### ☺️ 공유할 것
- 건형: 즐겨찾기 부분 하는중, 스켈레톤 쉽지않다
- 수현: 현대 바이브 애니메이션 따라하는중, 어느정도 작동됨, 스와이프 아래로 했을때 안예쁨 zindex
- 정우:  UI 잡았다 기능쪽 해야함 맵쪽 이슈, 수현님이 만들 음성인식 버튼 추가해놓음
- 지연:  스토리지로 이미지 불러오기, 길찾기 의문
- 두영: 구글로그인 + 파베Auth 적용

<img src="https://user-images.githubusercontent.com/48436020/215922657-6d6e73b1-bd11-475b-8c44-1f5dae5dca50.png" width=30%><img src="https://user-images.githubusercontent.com/48436020/215922826-fd299f0a-fc8c-41b9-a593-d1208b13a612.png" width=30%><img src="https://user-images.githubusercontent.com/48436020/215922828-d5b88af3-6f72-4ba2-8870-037b19664234.png" width=30%>

```swift
애플개발자사이트 필요
https://medium.com/firebase-developers/sign-in-with-apple-using-swiftui-and-firebase-10b7760aba60
023-01-31 10:29:15.678866+0900 Machacha[78731:1959611] [siwa] Authorization failed: Error Domain=AKAuthenticationError Code=-7026 "(null)" UserInfo={AKClientBundleID=lionlike.project.Machacha}
The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000.)
```

### 💻 오늘 할 일

- 건형: 프로필뷰,즐겨찾기에 스켈레톤뷰 적용, 로그인,로그아웃기능
- 정우: 카드뷰에 애니메이션 적용, 맵 이슈 잡기(오래걸릴듯)
- 지연: 리뷰 UI 구성
- 수현: 애니메이션 끝내기 
- 두영: 로그인 마무리

### 🙋 건의사항

- ContentView를 감싼 NavigationView → NavigationStack
- 푸드카트 모델 수정 필요? (프로필뷰에서 사용할)
- 등록할 사용자의 유저아이디가 필요 

- 즐겨찾기/별/하트/찜하기
  - 평점이 별이니, 하트로가자 (heart or heart.fill) 컬러셋 3번
  - 즐겨찾기로 통일
- 가봤어요
  - checkmark.seal , checkmark.seal.fill 3번 통일 선택x 그레이
- UX 테스트
  - 리뷰관리 pencil 통일 (square.and.pencil)
  - 푸드카트 모델
- let registerId: String // 등록한 유저 추가

1. 명동역 픽스?

- 명동&을지로
- 명동 점심 한탕
- 을지로 저녁 한탕
- 을지로 끝나고 한잔
- 떡볶ㅣ 맛있겠다
- 명동역 1시 6번출구
