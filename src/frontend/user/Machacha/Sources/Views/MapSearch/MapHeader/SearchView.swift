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
    var trimText: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }
    
    @State var text: String = ""
    @ObservedObject var voiceViewModel = VoiceViewModel()
    
    var body: some View {
        
        NavigationStack {
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
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color("Color2"), lineWidth: 1)
                        .frame(height: 50)
                }
                .padding(EdgeInsets(top: 30, leading: 10, bottom: 10, trailing: 10))

                
                
                List(searchResults, id: \.self) { result in
                    NavigationLink {
//                        SearchDetailView(name: result)
                    } label: {
                        Text(result)
                    }
                }
            }
        }
//        .onTapGesture {
//            hideKeyboard()
//        }
    }
    
    @ViewBuilder
    private func SearchDetailView(name: String) -> some View {
        VStack {
            Text(name)
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
