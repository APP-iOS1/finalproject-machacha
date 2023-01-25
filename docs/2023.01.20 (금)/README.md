# 🍢 마차챠

<p align="center"><img src="https://user-images.githubusercontent.com/48436020/214490359-37a07b11-51cb-4045-b7e3-1ca9c141b07d.jpeg" width=30%></p>

## 오늘의 기록 (23.01.20 금)

## 1. DB 구조
<details>
<summary>FoodCart</summary>
<div markdown="5">
    
```swift
struct FoodCart {
    let id: String
    let createdAt: Timestamp    // 가게가 등록된 시간
    let updatedAt: Timestamp    // 가게의 정보가 업데이트된 시간
    let geoPoint: GeoPoint      // 가게의 실제 좌표
    let region: String          // 동기준 ex) 명동, 을지로동
    let name: String            // 사용자가 등록할 포장마차의 이름
    let address: String         // 포장마차의 실제 위치
    let visitedCnt: Int         // 가게를 방문한 총 유저 수
    let favoriteCnt: Int        // 가게를 즐겨찾기로 등로한 유저 수
    let paymentOpt: [String]    // [카드, 현금, 계좌이체]
    let openingDays: [Bool]     // [월, 화, 수, 목, 금, 토, 일] 오픈한 날은 true로 바꿔줌
    let menu: [String: Int]     // 메뉴 Ex(붕어빵: 3000)
    let bestMenu: Int           // 아이콘을 위한 변수
    let imageId: [String]       // storage image
    let grade: Double           // 가게의 평점
    let reportCnt: Int          // 가게가 신고된 횟수
    let reviewId: [String]      // 가게에 대한 리뷰 정보
}
```
  
</div>
</details>
<details>
<summary>Review</summary>
<div markdown="5">
    
```swift
struct Review {
    let id: String
    let foodCartId: String          // foodCart id
    let grade: Double               // 리뷰의 평점
    let description: String         // 사용자 후기
    let reviewer: String            // 리뷰쓴 사람의 userID
    let createdAt: Timestamp
    let upadtedAt: Timestamp
    let imageId: [String]           // 사용자가 review 올린 사진들
}
```
  
</div>
</details>
<details>
<summary>User</summary>
<div markdown="5">
    
```swift
struct User {
    let id: String
    let createdAt: Timestamp
    let updatedAt: Timestamp
    let email: String
    let name: String            // 사용자가 회원가입 시 등록한 이름
    let favoriteId: [String]    // 즐겨찾기한 foodCart id
    let visitedId: [String]     // 내가 가본 foodCart id
    let profileId: String       // 유저의 프로필 사진
    let isFirstLogin: Bool      // 최초 로그인 여부
}
```
  
</div>
</details>
<details>
<summary>Magazine</summary>
<div markdown="5">
    
```swift
struct Magazine {
    let id: String
    let createdAt: Timestamp
    let updatedAt: Timestamp
    let foodCartId: [String]        // foodCart들의 id
    let description: String         // 매거진의 설명
    let pickTitle: String           // ~~~'s PICK
    let title: String               // Main Title
    let subTitle: String            // SubTitle
    let comment: String             // 큐레이터의 한마디
		let thumbnail: String           // 매거진의 Main Image, storageId
}
```
  
</div>
</details>

## 2. 지도 라이브러리 정하기
: Naver Map (기능적인 측면에서는 처음부터 개발해야하지만, 한국인들에게는 익숙한 UI)

## 3. 세미나 주제 정하기 (23.01.02 (목))
1. 건형 : UniTest, TDD, UITest, A/B Test
2. 수현 : Image Cashe(feat. stroage)
3. 정우 : Tuist 모듈화
4. 지연 : Concurrency
5. 두영 : login token(access, refresh), oauth, Jwt

## 4. 전체 스프린트
### 전체 목표
1. 20(금)~29(일)
    1. 건형(27, 28) : Settings(Navigation 것들 끝내기, 프로필 수정, 카카오 비지니스 계정 찾아보기)
    2. 수현(28) : Naver Map(pin, zoom 등) toy project
    3. 정우 : Map Marker Custom, DB 연결, Marker(modal를 통한 Detail UI), MapView UI
    4. 지연(24~26, 28, 29) : Detail UI(Review추가 까지, Network 제외)
    5. 두영(24~28) : Login(Naver, Google, Kakao), Clean Code(UserDefaults) → 검색 스스삭 
2. 30(월)~05(일)
    1. 건형 : Setting을 다 끝내고 싶어요
    2. 수현 : 매거진 완성
    3. 정우 : Map 마무리(이미지 클러스터링)
    4. 지연 : Detail (Network)
    5. 두영 : 등록 UI + DB
3. 06(월)~12(일) :
    1. 건형 : 관리자 앱(기능 위주), openCV 등록 OCR
    2. 수현 : 정우님쪽 도와줘야할듯합니다.
    3. 정우 : 알림, 애플 로그인
    4. 지연 : HomeView 및 추천 알고리즘
    5. 두영 : 알림 서버 및 알림
4. 13(월)~14(화) : 안된것 마무리
    1. 테스트 코드 작성, 발표준비, ppt
    2. 디자인 통일

### 5. 추가 기능 고려
1. Map Zoom 기능 제한
2. 검색 View (최근 검색어, 마이크 기능 등) 만들기
3. 반납 불가 지역
<p align="left"><img src="https://user-images.githubusercontent.com/48436020/214491743-931e0f27-96ad-48f6-973c-ff000efb6b13.png" width=30%></p>


## 🙋 건의사항
