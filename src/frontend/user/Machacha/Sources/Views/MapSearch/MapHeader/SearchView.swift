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
    var trimText: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack {
            SearchBar()
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        }
    }
    
    @ViewBuilder
    private func SearchDetailView(name: String) -> some View {
        VStack {
            Text(name)
        }
    }
    
    @ViewBuilder
    private func SearchBar() -> some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText) { editChanged in
                        self.getDatafromFirestore(query: self.searchText)
                    }
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    } else {
                        EmptyView()
                    }
                }
                List(searchResults, id: \.self) { result in
                    NavigationLink {
                        SearchDetailView(name: result)
                    } label: {
                        Text(result)
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    // firestore 실시간 쿼리
    func getDatafromFirestore(query: String) {
        let db = Firestore.firestore()
        db.collection("FoodCart").whereField("name", isEqualTo: query).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting data \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                self.searchResults = snapshot.documents.map { $0["name"] as! String }
            }
        }
    }
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
