//
//  RegisterView.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/31.
//

import SwiftUI
import Combine
import Firebase

struct RegisterView: View {
	
	@Environment(\.presentationMode) var presentation
	@ObservedObject var tabbarManager = TabBarManager.shared
	@EnvironmentObject var foodCartViewModel : FoodCartViewModel
	@ObservedObject var naverAPIVM : NaverAPIViewModel = NaverAPIViewModel()
	
	// OCR
//	@StateObject var ocrVM: OCRViewModel = OCRViewModel()
	@State private var imagePickerVisible: Bool = false
	
	// 위치 수정시 유지될 정보들
	@Binding var name : String
	@Binding var paymentOpt : [Bool]
	@Binding var openingDays : [Bool]
	@Binding var menu : [String : Int]
	@Binding var grade : Double
	@Binding var bestMenu : Int
	
	@Binding var menuCnt : Int
	@Binding var menuName : String
	@Binding var menuPrice : String
	
	//Alert 변수
	@State private var isDismissAlertShowing : Bool = false
	@State private var isRegisterAlertShowing : Bool = false
	
	//주소를 불러올 위도/경도
	var cameraCoord : (Double,Double)
	//@State private var Address : String = ""
	//@State private var region : String = ""
	
	
	private var isSelectedPaymentOpt : Bool {
		for opt in paymentOpt {
			if opt == true {
				return false
			}
		}
		return true
	}
	
	
	private var isSelectedOpeningDays : Bool {
		for day in openingDays {
			if day == true {
				return false
			}
		}
		return true
	}
	
	//등록 버튼 비활성화 여부
	private var isRegisterDisable : Bool {
		return (name=="") || (bestMenu == -1) || isSelectedPaymentOpt || isSelectedOpeningDays
	}
	
	// 메뉴추가 버튼 비활성화 여부
	private var isMenuAddBtnDisable : Bool {
		menuName==""&&menuPrice==""
	}
	
	var markerImage: String {
		switch bestMenu {
		case 0:
			return "bbungbread2"
		case 1:
			return "fishcake2"
		case 2:
			return "sweetpotato2"
		case 3:
			return "tteokboki2"
		case 4:
			return "takoyaki"
		case 5:
			return "hotteok"
		case 6:
			return "skewers"
		case 7:
			return "dessert"
		case 8:
			return "beverage"
		default:
			return "store2"
		}
	}
	
	var iconImages: [String] = ["bbungbread2","fishcake2","sweetpotato2","tteokboki2","takoyaki","hotteok","skewers","beverage","dessert","store2"]
	
	var iconLabels: [String] = ["붕어빵","오뎅","고구마","떡볶이","타코야끼","호떡","꼬치","음료","디저트","기타"]
	
	var body: some View {
		
		ScrollView(showsIndicators: false) {
			VStack{
				VStack(alignment: .leading,spacing: 25){
					//                    Text("가게 등록하기")
					//                        .font(.machachaTitle)
					//                    Spacer()
					AddressView()
                        .padding(.top,40)
					EditNameView()
					//RatingView()
					DaysView()
					PayView()
					BestMenuView()
					MenuView()
				}
				// 등록하기 버튼
				Button(action: {
					isRegisterAlertShowing = true
				}) {
					Text("등록하기")
						.font(.machachaTitle)
						.foregroundColor(isRegisterDisable ? .gray: Color("Color3"))
                        .frame(width: Screen.maxWidth*0.7)
				}
				.disabled(isRegisterDisable)
				.buttonStyle(.bordered)
				.tint(isRegisterDisable ? .secondary: Color("Color3"))
				.padding()
                .alert("포장마차를 등록하시겠습니까?", isPresented: $isRegisterAlertShowing, actions: {
                    Button("수정하기", role: .cancel) {
                        isRegisterAlertShowing = false
                    }
                    Button("등록하기") {
                        let foodCart : FoodCart = FoodCart(id: UUID().uuidString, createdAt: Date.now, updatedAt: Date.now, geoPoint: GeoPoint(latitude: cameraCoord.0, longitude: cameraCoord.1), region: naverAPIVM.region, name: name, address: naverAPIVM.address, visitedCnt: 0, favoriteCnt: 0, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: [], grade: grade, reportCnt: 0, reviewId: [], registerId: UserViewModel.shared.uid!)
                        foodCartViewModel.addFoodCart(foodCart)
                        tabbarManager.isShowingModal = false
                        SoundManager.instance.playSound(sound: .register)
                        
                    }
                }, message: {
                    Text("작성하신 내용을 제출하면 더 이상 수정할 수 없습니다.")
                })
				
			}
		}
        .padding()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        //툴바
        .toolbarBackground(Color("Color3"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
		//툴바
		.toolbar(content: {
            ToolbarItem(placement: .principal) {
                    Text("가게 등록")
                    .foregroundColor(Color("bgColor"))
                    .font(.machachaHeadlineBold)
                        .accessibilityAddTraits(.isHeader)
                }
			// 오른쪽 툴바 버튼 - 등록 취소
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					if (name != "") || (bestMenu != -1) || !isSelectedPaymentOpt || !isSelectedOpeningDays {
						isDismissAlertShowing = true
					}else{
						tabbarManager.isShowingModal = false
						tabbarManager.curTabSelection = tabbarManager.preTabSelection
					}
				} label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(Color("bgColor"))
				}
                .alert("가게 등록을 취소하시겠습니까?", isPresented: $isDismissAlertShowing, actions: {
                    Button("계속 작성", role: .cancel) {
                        //..
                    }
                    Button("등록 취소",role: .destructive) {
                        tabbarManager.isShowingModal = false
                        tabbarManager.curTabSelection = tabbarManager.preTabSelection
                    }
                }, message: {
                    Text("취소하면 현재 작성한 가게 정보가 사라집니다.")
                })
			} // ToolbarItem
		})
		.background(Color("bgColor"))
		.onAppear{
			naverAPIVM.fetchReverseGeocode(latitude: cameraCoord.0, longitude: cameraCoord.1)
		}
		.sheet(isPresented: $imagePickerVisible) {
//			MyUIImagePicker(imagePickerVisible: $imagePickerVisible, selectedImage: $ocrVM.uiImage)
//				.onDisappear {
//					ocrVM.reconizeTextKorean() // ocr
//				}
		}
	}
	
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}

// MARK: - extension View Deatil Component
extension RegisterView {
	
	// 주소 표시 뷰
	
	@ViewBuilder
	private func AddressView() -> some View {
		VStack(alignment: .leading){
			HStack{
				Text("포장마차 위치")
					.font(.machachaHeadlineBold)
				Spacer()
				Button(action: {
					self.presentation.wrappedValue.dismiss()
				}) {
					Text("수정")
                        .font(.machachaHeadline)
                        .foregroundColor(Color("Color3"))
				}
			}
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color(.gray))
				.opacity(0.1)
				.frame(height: 43)
				.overlay {
					Text("\(naverAPIVM.address)")
						.font(.machachaHeadline)
						.padding(8)
				}
		}
	}
	
	
	// 가게 이름 입력 뷰
	@ViewBuilder
	private func EditNameView() -> some View {
		VStack(alignment : .leading){
			Text("가게 이름")
				.font(.machachaHeadlineBold)
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(Color(.gray))
				.opacity(0.1)
				.frame(height: 43)
				.overlay {
					TextField("ex) 마차챠붕어빵집, 망포역3번출구오른쪽떡볶이", text: $name)
                        //글자수 20자 이내
                        .onReceive(Just(name), perform: { _ in
                                        if 20 < name.count {
                                            name = String(name.prefix(20))
                                        }
                                    })
						.font(.machachaHeadline)
						.textInputAutocapitalization(.never)
						.disableAutocorrection(true)
						.padding(8)
				}
            HStack{
                Spacer()
                Text("\(name.count) / 20 자")
                    .font(.machachaFootnoteBold)
                    .foregroundColor(name.count == 20 ? Color("Color1") : .secondary)
            }
		}
		
	}
	
	// 평점 선택 뷰
	@ViewBuilder
	private func RatingView() -> some View {
		VStack(alignment: .leading){
			Text("평점")
				.font(.machachaHeadlineBold)
			HStack{
				ForEach(0..<5,id: \.self){ index in
					Image(systemName: "star.fill")
						.foregroundColor(Double(index) < grade ? Color("mainColor") : Color.secondary)
						.onTapGesture {
							grade = Double(index+1)
						}
				}
			}
			.padding(.top,3)
		}
	}
	
	// 날짜 선택 뷰
	@ViewBuilder
	private func DaysView() -> some View {
		
		let dayArr = ["월", "화", "수", "목", "금", "토", "일"]
		
		HStack {
			Image(systemName:"clock")
			ForEach(0..<7, id: \.self) { day in
				Text(dayArr[day])
					.font(.machachaHeadline)
					.padding(6)
					.overlay {
						Circle()
							.opacity(0.1)
					}
					.foregroundColor(openingDays[day] ?
									 Color("Color3") : Color(.gray))
					.onTapGesture {
						openingDays[day].toggle()
					}
			}
		}
	}
	
	//결제수단 선택 뷰
	@ViewBuilder
	private func PayView() -> some View {
		let paymentArr = ["현금", "계좌이체", "카드"]
		
		HStack {
			Image(systemName:"creditcard")
				.resizable()
				.frame(width: 17, height: 15)
			ForEach(paymentArr.indices, id: \.self) { payment in
				Text(paymentArr[payment])
					.font(.machachaHeadline)
					.padding(6)
					.overlay {
						RoundedRectangle(cornerRadius: 14)
							.opacity(0.1)
					}
					.foregroundColor(paymentOpt[payment] ?
									 Color("Color3") : Color(.gray))
					.onTapGesture {
						paymentOpt[payment].toggle()
					}
			}
		}
	}
	
	// 베스트메뉴 선택 뷰
	@ViewBuilder
	private func BestMenuView() -> some View {
		VStack(alignment : .leading){
			Text("베스트메뉴")
				.font(.machachaHeadlineBold)
			ScrollView(.horizontal,showsIndicators: false){
				HStack{
					ForEach(0..<10, id: \.self) { index in
						//베스트 메뉴 카드
						Group{
							VStack{
								Image(iconImages[index])
									.resizable()
									.frame(width: Screen.maxWidth*0.1, height: Screen.maxWidth*0.1)
								Text(iconLabels[index])
									.frame(width: Screen.maxWidth*0.16)
									.font(.machachaFootnote)
							}
							.opacity((index == bestMenu) ? 1 : 0.25)
							.background{
								RoundedRectangle(cornerRadius: 14)
									.frame(width: Screen.maxWidth*0.18, height: Screen.maxWidth*0.18)
                                    .foregroundColor(.gray)
									.opacity(0.2)
							}
							.onTapGesture {
								bestMenu = index
							}
						}
					}
					.padding(4)
				}
				
			}.frame(height: Screen.maxHeight/10)
		}
	}
	
	
	// 메뉴 등록 뷰
	@ViewBuilder
	private func MenuView() -> some View {
		VStack(alignment: .leading){
			HStack{
				Text("메뉴 정보")
					.font(.machachaHeadlineBold)
				Text("(선택)")
					.font(.machachaHeadline)
					.foregroundColor(.secondary)
				Menu {
					Button {
						
					} label: {
						Label("카메라", systemImage: "camera")
					}
					Button {
						imagePickerVisible.toggle() // image 선택
					} label: {
						Label("앨범", systemImage: "photo.artframe")
					}
				} label: {
					Image(systemName: "camera.fill")
						.foregroundColor(Color("Color3"))
				} // Menu
			}
			
			// 가격 collection
//			ZStack {
//				ScrollView(.horizontal, showsIndicators: false) {
//					LazyHStack {
//						ForEach(ocrVM.menu.sorted(by: <), id: \.self) { menu in
//							Button {
//								menuName = menu
//							} label: {
//								Text(menu)
//									.font(.machachaHeadline)
//									.padding(6)
//									.overlay {
//										RoundedRectangle(cornerRadius: 14)
//											.opacity(0.1)
//									}
//									.foregroundColor(Color("Color3"))
//							}
//						} // ForEach
//						
//						
//						if !ocrVM.menu.isEmpty && !ocrVM.price.isEmpty {
//							Divider()
//						}
//						
//						ForEach(ocrVM.price.sorted(by: <), id: \.self) { price in
//							Button {
//								menuPrice = price
//							} label: {
//								Text(price)
//									.font(.machachaHeadline)
//									.padding(6)
//									.overlay {
//										RoundedRectangle(cornerRadius: 14)
//											.opacity(0.1)
//									}
//									.foregroundColor(Color("Color3"))
//							}
//						} // ForEach
//					} // LazyHStack
//				} // ScrollView
//				if ocrVM.isLoding {
//					Text("")
//						.padding(6)
//						.overlay {
//							ProgressView()
////								.scaleEffect(3)
//								.tint(Color("Color3"))
//						}
//				}
//			}
			//메뉴 입력
			HStack{
				TextField("메뉴이름", text: $menuName)
					.font(.machachaHeadline)
					.textInputAutocapitalization(.never)
					.disableAutocorrection(true)
					.textFieldStyle(.roundedBorder)
					.frame(width: Screen.maxWidth/4*2)
				
				//Divider()
				
				TextField("가격", text: $menuPrice)
					.font(.machachaHeadline)
					.textInputAutocapitalization(.never)
					.disableAutocorrection(true)
					.textFieldStyle(.roundedBorder)
				//숫자만 입력받기
					.keyboardType(.numberPad)
					.modifier(JustEditNumberModifier(number : $menuPrice))
					.frame(width: Screen.maxWidth/4)
				
				Spacer()
				Button(action: {
					menu[menuName] = Int(menuPrice)!
					menuCnt += 1
					menuName = ""
					menuPrice = ""
				}) {
					Image(systemName: "plus.circle")
						.resizable()
						.scaledToFit()
						.frame(width:25)
				}
				.foregroundColor(isMenuAddBtnDisable ? .secondary : Color("Color3"))
				.disabled(isMenuAddBtnDisable)
			}
            .frame(width: Screen.maxWidth*0.9)
			
			//입력한 메뉴 정보
			ForEach(Array(menu.keys),id:\.self){ menuName in
				HStack{
					Text(menuName)
						.font(.machachaHeadline)
						.frame(width: Screen.maxWidth/4*2,alignment: .leading)
					
					//Divider()
					
					Text("\(menu[menuName]!) 원")
						.font(.machachaHeadline)
						.frame(width: Screen.maxWidth/4,alignment: .trailing)
					
					Spacer()
					//입력 메뉴 삭제 버튼
					Button(action: {
						menu.removeValue(forKey: menuName)
					}) {
						Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25)
							.foregroundColor(.secondary)
					}
				}
                .frame(width: Screen.maxWidth*0.9)
			}
			
		}
	}
	
	
}


// MARK: - Modifier 텍스트필드에서 숫자만 입력받는 모디파이어
struct JustEditNumberModifier : ViewModifier {
	@Binding var number : String
	
	func body(content: Content) -> some View {
		content
		// onReceive(_:perform:) : iOS13 이상, publisher 가 방출한 이벤트를 받아 view 에서 어떠한 action 을 하게 된다.
		// Just는 실패할 수 없고, 항상 값을 생산하는 Publisher 생성자
			.onReceive(Just(number)) { _ in
				
				// Number가 아닌 문자는 걸러내고, 걸러낸 문자열과 입력받은 문자열이 다르면 걸러낸 문자열로 대치
				let filteredString = number.filter { $0.isNumber }
				if filteredString != number {
					number = filteredString
				}
			}
		
	}
}

// MARK: - 프리뷰
struct RegisterView_Previews: PreviewProvider {
    static var cameraCoord : (Double,Double) = (37.56621548663492, 126.99223256544298)
    @State static var name : String = ""
    @State static var paymentOpt : [Bool] = Array(repeating: false, count: 3)
    @State static var openingDays : [Bool] = Array(repeating: false, count: 7)
    @State static var menu : [String : Int] = [:]
    @State static var grade : Double = 0
    @State static var bestMenu : Int = -1

    @State static var menuCnt : Int = 1
    @State static var menuName : String = ""
    @State static var menuPrice : String = ""


    static var previews: some View {
        NavigationView{
            RegisterView(name: $name, paymentOpt: $paymentOpt, openingDays: $openingDays, menu: $menu, grade: $grade, bestMenu: $bestMenu, menuCnt: $menuCnt, menuName: $menuName, menuPrice: $menuPrice, cameraCoord: cameraCoord)
        }
    }
}
