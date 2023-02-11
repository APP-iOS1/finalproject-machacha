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
    @State var searchResults: [String] = []
    @State var doneTextFieldEdit: Bool = true
    @EnvironmentObject var foodCartVM: FoodCartViewModel
    @EnvironmentObject var mapSearchVM: MapSearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    TextField("검색어를 입력해주세요", text: $searchText)
                    .padding(.leading, 24)
                    .modifier(TextFieldClearButton(text: $searchText))
                    .overlay {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("Color2").opacity(0.8))
                                .padding(.leading, 4)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color("Color2"), lineWidth: 2)
                            .frame(height: 40)
                        
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                
                
                
                if searchText.isEmpty {
                    Text("검색 결과가 없습니다.")
                    Spacer()
                } else {
                    List {
                        ForEach(foodCartVM.foodCarts.filter{$0.region.trimmingCharacters(in: .whitespaces).hasPrefix(searchText) || (searchText == "")}) { result in
                            Text(result.region)
                                .onTapGesture {
                                    mapSearchVM.foodCarts = [result]
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                    .listStyle(.plain)
                }
                
                // 주소로만 검색 가능

            }
//            .onTapGesture {
//                hideKeyboard()
//            }
        }
        .onAppear {
            print("count : \(foodCartVM.foodCarts.count)")
        }
    }

    
    
    //    // firestore 실시간 쿼리
    //    func getDatafromFirestore(query: String) {
    //        let db = Firestore.firestore()
    //        db.collection("FoodCart").whereField("name", isEqualTo: query).addSnapshotListener { snapshot, error in
    //            if let error = error {
    //                print("Error getting data \(error.localizedDescription)")
    //                return
    //            }
    //
    //            if let snapshot = snapshot {
    //                self.searchResults = snapshot.documents.map { $0["name"] as! String }
    //            }
    //        }
    //    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
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
