import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

enum UserCheck : Error {
    case correct
    case firstLogin
    case incorrect
    case checking
}

class UserViewModel: ObservableObject {
    
    static let shared = UserViewModel()
    
    @Published var users: [User] = []
    
    //로그인한 현재 유저아이디
    let uid : String? = FirebaseAuth.Auth.auth().currentUser?.uid
    //로그인한 유저정보
    @Published var user : User = User(id: "", isFirstLogin: true, email: "", name: "", profileId: "", favoriteId: [], visitedId: [], updatedAt: Date(), createdAt: Date())
    @Published var userCheck : UserCheck = .checking
    
    let db = Firestore.firestore()
    
    
    //하나의 유저정보
    func requestUserData() {
        db.collection("User").document(uid ?? "").getDocument { snapshot,error in
            if let snapshot {
                let docData = snapshot.data()
                let id: String = docData?["id"] as? String ?? ""
                let name: String = docData?["name"] as? String ?? ""
                let email: String = docData?["email"] as? String ?? ""
                let isFirstLogin: Bool = docData?["isFirstLogin"] as? Bool ?? true
                let createdAt: Date = docData?["createdAt"] as? Date ?? Date()
                let updatedAt: Date = docData?["updatedAt"] as? Date ?? Date()
                let profileId : String = docData?["profileId"] as? String ?? ""
                let favoriteId : [String] = docData?["profileId"] as? [String] ?? []
                let visitedId : [String] = docData?["profileId"] as? [String] ?? []
                
                
                print("name: \(name)")
                
                
                let user: User = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt, createdAt: createdAt)
                self.user = user
            }
            
        }
    }
    // FireStore에 중복된 닉네임 확인
    // 제대로 작동하지 않음, 비동기처리필요?
    func queryNameCheck(_ name : String) -> Bool {
        var result : Bool = true
        let query = db.collection("User").whereField("name", isEqualTo: name)
        let _ = query.getDocuments() { qs,err in
            if qs!.documents.isEmpty {
                print("이미 있는 닉네임")
                result = false
            }
            else {
                print("사용 가능한 닉네임")
                result = true
            }
        }
        return result
    }
    
    // FireStore에 등록된 유저 확인
    func queryIdCheck( _ uid : String, completion : @escaping (Result<Bool,UserCheck>)->Void){
        let query = db.collection("User").whereField("id", isEqualTo: uid)
        query.getDocuments() { qs,err in
            if qs!.documents.isEmpty {
                print("등록되지 않은 회원입니다")
                completion(.success(false))
                return
            }
            else {
                print("이미 등록된 회원입니다")
                completion(.success(true))
                return
            }
        }
    }
    
    //로그인한 유저의 정보를 찾기
    func requestUserCheck() -> Void {
        guard let uid else {
            return
        }
        queryIdCheck(uid) { result in
            switch result {
            case .success(let isCheck) :
                DispatchQueue.main.async {
                    print("성공 \(isCheck)")
                    if isCheck {
                        // 파이어스토어에 이미 유저정보가 있는 경우
                        self.db.collection("User").document(uid).getDocument { snapshot,error in
                            if let snapshot {
                                let docData = snapshot.data()
                                let id: String = docData?["id"] as? String ?? ""
                                let name: String = docData?["name"] as? String ?? ""
                                let email: String = docData?["email"] as? String ?? ""
                                let isFirstLogin: Bool = docData?["isFirstLogin"] as? Bool ?? true
                                let createdAt: Date = docData?["createdAt"] as? Date ?? Date()
                                let updatedAt: Date = docData?["updatedAt"] as? Date ?? Date()
                                let profileId : String = docData?["profileId"] as? String ?? ""
                                let favoriteId : [String] = docData?["profileId"] as? [String] ?? []
                                let visitedId : [String] = docData?["profileId"] as? [String] ?? []
                                
                                
                                print("name: \(name)")
                                
                                
                                let user: User = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt, createdAt: createdAt)
                                
                                if user.isFirstLogin {
                                    self.userCheck = .firstLogin
                                }else{
                                    self.userCheck = .correct
                                }
                                
                                self.user = user
                                print(self.userCheck)
                            }
                        }
                        
                    }else{
                        //파이어스토어에 유저정보가 없는 경우 새로운 유저를 등록함
                        self.addUser(User(id: uid, isFirstLogin: true, email: FirebaseAuth.Auth.auth().currentUser?.email ?? "test", name: "test", profileId: "", favoriteId: [], visitedId: [], updatedAt: Date(), createdAt: Date()))
                        self.userCheck = .firstLogin
                    }
                }
            case .failure(_):
                print("실패")
                self.userCheck = .incorrect
            }
        }
    }
    
    func fetchUsers() {
        // 콜렉션
        db.collection("User")
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
                        let isFirstLogin: Bool = docData["isFirstLogin"] as? Bool ?? true
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
        db.collection("User")
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
    
    //첫로그인시 이름 입력 및 isFirstLoign -> false
    func firstLogin(_ name: String) -> Bool {
        guard let uid else { return false}
        
        let result = queryNameCheck(name)
        
        if result {
            db.collection("User")
                .document(uid)
                .updateData([
                    "name" : name,
                    "isFirstLogin" : false
                ])
            fetchUsers()
            return true
        }
        
        return false
    }
    
    
}
