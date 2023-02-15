//
//  NoticeViewModel.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/13.
//

import FirebaseStorage
import FirebaseFirestore
import Alamofire
import Combine

class NoticeViewModel: ObservableObject {
    //MARK: Property Wrapper
    @Published var title: String = ""
    @Published var body: String = ""
    @Published var contents: String = ""
    // machacha-push의 deviceToken
    @Published var userId: [String] = []
    @Published var userTokens: [String] = []
    
    //MARK: Property
    private var subscription = Set<AnyCancellable>()    // disposeBag
    private let database = Firestore.firestore()
    
    func initData() {
        title = ""
        body = ""
        contents = ""
    }
    
    // User Data Fetch
    func fetchUserId() async throws -> [String] {
        var userId = [String]() // 비동기 통신으로 받아올 Property
        
        let userSnapshot = try await database.collection("User").getDocuments() // 첫번째 비동기 통신
        
        for document in userSnapshot.documents {
            let id: String = document.documentID
            userId.append(id)
        }
        
        return userId
    }
    
    // User Token Fetch
    func fetchUserToken() async throws -> [String] {
        var userToken = [String]() // 비동기 통신으로 받아올 Property
        
        do {
            let querysnapshot = try await database.collection("FCMToken").getDocuments()
            
            for document in querysnapshot.documents {
                let data = document.data()
                
                let fcmToken = data["fcmToken"] as? String ?? ""
                userToken.append(fcmToken)
            }
        } catch {
            print("fetch FCMToken error: \(error.localizedDescription)")
        }
        
        return userToken
    }
    
    // 전체 공지
    func sendMessageToDevice() async {
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        print("🍎🍎sending json ...")
        
        //        lionlike.project.MachachaNoti의 ServerKey
        let serverKey = "AAAAdbzTdUQ:APA91bFbBhrYIkJ67QiAsVKTGzWtKdUCgSyAw6FBSz9tZA1JRlnW24zhnT6KONSOSajEbe840hWlhBu87IaDRpKvm5srwF_aXKWHgC4U5KsFh7LuGkWu9xjeKDiVuRg0XCkaKF97Z1WT"
        
        for userToken in userTokens {
            let json: [String: Any] = [
                "to": userToken,
                "notification": [
                    "title": title,
                    "body": body
                ],
                "data": [
                    "user_name": "jungwoo"
                ]
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 10
            
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: json, options: [])
            } catch {
                print("http BOdy Error ")
            }
            
            AF.request(request).responseString { response in
                switch response.result {
                case .success:
                    print("🍎🍎Post 성공")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        //				// 임시: 전체 알림이 성공한다면 한번 결합해보고 싶네요. 제가 원래 쓰는 Network base code 입니다.
        //        AF.request(NoticeRouter.postNotice(deviceToken: deviceToken, title: title, contents: contents))
        //					.publishDecodable(type: Notification.self)
        //					.value() // 값만 가져오기
        //					.receive(on: DispatchQueue.main)
        //					.sink(receiveCompletion: { [weak self] in
        //						guard case .failure(let error) = $0 else { return }
        //						switch error.responseCode {
        //						case 400: // 요청 에러 발생했을 때
        //							break
        //						case 500: // 서버의 내부적 에러가 발생했을 때
        //							break
        //						default:
        //							break
        //						}
        //					}, receiveValue: { [weak self] receivedValue in
        //						print(#file, #function, #line, "Success")
        //					})
        //					.store(in: &subscription)
    }
    
    // MARK: - 서버에 NoiceView에서 입력한 전체 공지의 데이터들을 Add하는 Method
    func addNotice() async {
        do {
            let notificationId = UUID().uuidString
            try await database
                .collection("Notification")
                .document(notificationId)
                .setData(["id": notificationId,
                          "userId": userId,
                          "navigationType": "all",
                          "title": title,
                          "contents": contents,
                          "updatedAt": Date(),
                          "createdAt": Date()
                         ])
        } catch {
            print("addNotice error: \(error.localizedDescription)")
        }
    }
}
