# 🍢 마차챠

<p align="center"><img src="https://user-images.githubusercontent.com/48436020/213209241-66a73bea-bcda-4152-90b5-929f9a035e5f.png" width=30%></p>

## 오늘의 기록 (23.01.16 월)

### 역할 분배

|이름|주|보조|
|:-:|:-:|:-:|
|건형|Tab5(프로필)|Tab3(등록)|
|수현|Tab4(매거진), Splash|Tab2(검색), 로그인|
|정우|Tab5(프로필), 로그인(애플), 알림|Tab1(홈/디테일)|
|지연|Tab1(홈/디테일)|Tab4(매거진), Splash|
|두영|Tab3(등록), 로그인(소셜), 알림|Splash|

### 기능 정리
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

