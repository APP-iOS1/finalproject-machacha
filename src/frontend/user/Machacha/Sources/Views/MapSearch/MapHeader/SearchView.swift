//
//  SearchView.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/02/09.
//

import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    
    @State var searchText = ""
    @Binding var currentIndex: Int
    @State var searchResults: [String] = []
    @State var doneTextFieldEdit: Bool = true
    @EnvironmentObject var foodCartVM: FoodCartViewModel
    @EnvironmentObject var mapSearchVM: MapSearchViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var fromSearchView: Bool

    @State var text: String = ""
    @ObservedObject var voiceViewModel = VoiceViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("bgColor")
                VStack {
                    HStack {

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color("Color2").opacity(0.8))
                            .padding(.leading, 10)
                        
                        TextField("검색어를 입력해주세요", text: $searchText, onEditingChanged: { editChanged in
                            //   self.getDatafromFirestore(query: self.searchText)
                            doneTextFieldEdit = editChanged ? false : true
                        }, onCommit: {
                            doneTextFieldEdit = true
                        })
    //                    .padding(.leading, 36)
                        .modifier(TextFieldClearButton(text: $searchText))
                        
                        VoiceView(text: $searchText, voiceViewModel: voiceViewModel)
                            .frame(width: 40, height: 40)
                            .padding(.top, 8.2)
                            .padding(.trailing, 2)

                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color("Color2"), lineWidth: 1)
                            .frame(height: 50)
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                    

                    //MARK: - 참고용 ) 음성인식이 성공하면 바로 인식된 키워드로 다음화면으로 이동할 수 있는 코드
    //                NavigationLink(destination: Test3(text: $text), isActive: $voiceViewModel.final) { }
          
                    if searchText.isEmpty {
                        Text("검색 결과가 없습니다.")
                            .padding(.top, 40)
                        Spacer()
                    } else {
                        ScrollView (showsIndicators: false) {
                            LazyVStack (alignment: .leading) {
                                ForEach(foodCartVM.foodCarts.filter{$0.region.trimmingCharacters(in: .whitespaces).hasPrefix(searchText) || (searchText == "")}) { result in
                                    Text(result.region)
                                        .onTapGesture {
                                            // 화면을 되돌아갈 때 검색된 데이터만 보여줘야함
                                            currentIndex = 0
                                            Coordinator.shared.removeMarkers()
                                            mapSearchVM.foodCarts = [result]
                                            Coordinator.shared.foodCarts = mapSearchVM.foodCarts
                                            Coordinator.shared.setupMarkers()
                                            fromSearchView.toggle()
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                        .background( Color("bgColor"))
                                    Divider()
                                    
                                }
                            }
//                            if !foodCartVM.foodCarts.filter{$0.region.trimmingCharacters(in: .whitespaces).hasPrefix(searchText) {
//                                Text("찾지 못함")
//                                    .listRowBackground(Color("bgColor"))
//                            }
                            
                        }
//                        .listStyle(.plain)
//                        .listRowBackground(Color("bgColor"))
                        .background( Color("bgColor"))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                    }
                    
                    // 주소로만 검색 가능

                }
            }
//            .onTapGesture {
//                hideKeyboard()
//            }
        }
        .background(Color("bgColor"))
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden()
        .navigationBarTitle("검색", displayMode: .inline)
        .toolbarBackground(Color("Color3"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar) // 글자색 변경
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            } // ToolbarItem
        })
    }

}

struct SearchView_Previews: PreviewProvider {
    @State static var currentIndex: Int = 0
    @State static var fromSearchView = false
    static var previews: some View {
        SearchView(currentIndex: $currentIndex, fromSearchView: $fromSearchView)
            .environmentObject(MapSearchViewModel())
            .environmentObject(FoodCartViewModel())
    }
}



//화면 터치시 키보드 숨김
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
