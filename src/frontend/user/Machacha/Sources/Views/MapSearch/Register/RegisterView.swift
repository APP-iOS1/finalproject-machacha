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
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var foodCartViewModel : FoodCartViewModel
    @ObservedObject var naverAPIVM : NaverAPIViewModel = NaverAPIViewModel()
    
    @State var name : String = ""
    @State var paymentOpt : [Bool] = Array(repeating: false, count: 3)
    @State var openingDays : [Bool] = Array(repeating: false, count: 7)
    @State var menu : [String : Int] = [:]
    @State var grade : Double = 0
    @State var imageId : [String] = []
    @State var bestMenu : Int = -1
    
    @State private var menuCnt : Int = 1
    @State private var menuName : String = ""
    @State private var menuPrice : String = ""
    
    //주소를 불러올 위도/경도
    var cameraCoord : (Double,Double)
    //@State private var Address : String = ""
    //@State private var region : String = ""
    
    //등록 버튼 비활성화 여부
    private var isRegisterDisable : Bool {
        var isSelectedPaymentOpt : Bool {
            for opt in paymentOpt {
                if opt == true {
                    return false
                }
            }
            return true
        }
        
        var isSelectedOpeningDays : Bool {
            for day in openingDays {
                if day == true {
                    return false
                }
            }
            return true
        }
        
        
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
        default:
            return "store2"
        }
    }
    var iconImages: [String] = ["bbungbread2","fishcake2","sweetpotato2","tteokboki2","store2"]
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack{
                VStack(alignment: .leading,spacing: 25){
                    Text("가게 등록하기")
                        .font(.machachaTitle)
                    Spacer()
                    AddressView()
                    EditNameView()
                    RatingView()
                    DaysView()
                    PayView()
                    BestMenuView()
                    MenuView()
                }
                Button(action: {
                    let foodCart : FoodCart = FoodCart(id: UUID().uuidString, createdAt: Date.now, updatedAt: Date.now, geoPoint: GeoPoint(latitude: cameraCoord.0, longitude: cameraCoord.1), region: naverAPIVM.region, name: name, address: naverAPIVM.address, visitedCnt: 0, favoriteCnt: 0, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: [], grade: grade, reportCnt: 0, reviewId: [], registerId: UserViewModel.shared.uid!)
                    foodCartViewModel.addFoodCart(foodCart)
                    dismiss()
                }) {
                    Text("등록하기")
                        .font(.machachaTitle)
                        .foregroundColor(isRegisterDisable ? .secondary: Color("Color3"))
                }
                .disabled(isRegisterDisable)
                .buttonStyle(.bordered)
                .tint(isRegisterDisable ? .secondary: Color("Color3"))
                .padding()
                
            }
        }
        .padding()
        .onAppear{
            naverAPIVM.fetchReverseGeocode(latitude: cameraCoord.0, longitude: cameraCoord.1)
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
            Text("포장마차 위치")
                .font(.machachaHeadlineBold)
            HStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.gray))
                    .opacity(0.1)
                    .frame(height: 35)
                    .overlay {
                        Text("\(naverAPIVM.address)")
                            .font(.machachaHeadline)
                            .padding(8)
                    }
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
                .frame(height: 35)
                .overlay {
                    TextField("ex) 마차챠붕어빵집, 망포역3번출구오른쪽떡볶이", text: $name)
                        .font(.machachaHeadline)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(8)
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
                    ForEach(0..<5, id: \.self) { index in
                        Image(iconImages[index])
                            .resizable()
                            .frame(width: 60, height: 60)
                        
                            .opacity((index == bestMenu) ? 1 : 0.1)
                            .padding(6)
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .opacity(0.1)
                            }
                            .onTapGesture {
                                bestMenu = index
                            }
                    }
                }
                
            }.frame(height: Screen.maxHeight/10)
        }
    }
    
    
    // 메뉴 등록 뷰
    @ViewBuilder
    private func MenuView() -> some View {
        VStack(alignment: .leading){
            Text("메뉴 정보")
                .font(.machachaHeadlineBold)
            //메뉴 입력
            HStack{
                TextField("메뉴이름", text: $menuName)
                    .font(.machachaHeadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: Screen.maxWidth/4*2)
                
                Divider()
                
                TextField("가격", text: $menuPrice)
                    .font(.machachaHeadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                //숫자만 입력받기
                    .keyboardType(.numberPad)
                    .modifier(JustEditNumberModifier(number : $menuPrice))
                    .frame(width: Screen.maxWidth/4)
                
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
            
            //입력한 메뉴 정보
            ForEach(Array(menu.keys),id:\.self){ menuName in
                HStack{
                    Text(menuName)
                        .font(.machachaHeadline)
                        .frame(width: Screen.maxWidth/4*2)

                    Divider()

                    Text("\(menu[menuName]!) 원")
                        .font(.machachaHeadline)
                        .frame(width: Screen.maxWidth/4)
                }
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
