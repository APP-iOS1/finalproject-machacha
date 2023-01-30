import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    
    let database = Firestore.firestore()
    
    
    // 지금 이게 아예 잘 가져오고 있지 않음
    var userEmailList: [String] {
        return users.map{ $0.email }
    }
    
    var userNickNameList: [String] {
        return users.map { $0.name }
    }

    func fetchUsers() {
        // 콜렉션
        database.collection("User")
            .getDocuments { (snapshot, error) in
                // 계속 중복으로 쌓이는 것 해결
                self.users.removeAll()
                
                // snapshot? User 밑에 있는거 전체 들고옴
                if let snapshot {
                    for document in snapshot.documents {
                        
                        let id: String = document.documentID

                        print("\(document.documentID)")
                        let docData = document.data()
//
                        let name: String = docData["name"] as? String ?? ""
                        let email: String = docData["email"] as? String ?? ""
                        let isFirstLogin: Bool = docData["isFirstLogin"] as? Bool ?? false
                        let createdAt: Date = docData["createdAt"] as? Date ?? Date()
                        let updatedAt: Date = docData["updatedAt"] as? Date ?? Date()
                        let profileId : String = docData["profileId"] as? String ?? ""
                        let favoriteId : [String] = docData["profileId"] as? [String] ?? []
                        let visitedId : [String] = docData["profileId"] as? [String] ?? []
                        
                        
                        print("name: \(name)")


                        let user: User = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt, createdAt: createdAt)

                        print("user : \(user)")
                        self.users.append(user)
                        print("users: \(self.users)")
                    }
                }
            }
    }
    
  
    func addUser(_ user: User) {
        database.collection("User")
            .document(user.id)
            .setData(["id": user.id,
                      "name": user.name,
                      "email": user.email,
                      "isFirstLogin": user.isFirstLogin,
                      "profileId": user.profileId,
                      "favoriteId": user.favoriteId,
                      "visitedId": user.visitedId,
                      "updatedAt": user.updatedAt,
                      "createdAt": user.createdAt
                     ])
        fetchUsers()
    }
    
    // func emailDuplicateCheck(_ email: String) -> Bool
    func emailDuplicateCheck(_ email: String) -> Bool {
        // 중복이다
        if userEmailList.contains(email) {
            return true
        }
        //중복아니다
        return false
        
 
    }
    
    func nickNameDuplicateCheck(_ nickName: String) -> Bool {
        if userNickNameList.contains(nickName) {
            return true
        } else {
            return false
        }
    }

  
}
