//
//  NoticeViewModel.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/13.
//

import Firebase
import FirebaseStorage
import Alamofire
import Combine

class NoticeViewModel: ObservableObject {
	@Published var title: String = ""
	@Published var contents: String = ""
	@Published var deviceToken: String = ""
	
	private var subscription = Set<AnyCancellable>()    // disposeBag

	func initData() {
		title = ""
		contents = ""
		deviceToken = ""
	}
	
	// 전체 공지
	func sendMessageToDevie() {
		guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
		
		let json: [String: Any] = [
			"to": deviceToken,
			"notification": [
				"title": title,
				"body": contents
			]
		]
		
		let serverKey = "" // 임시: lionlike.project.MachachaNoti의 ServerKey가 들어갈 예정
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
		
		let session = URLSession(configuration: .default)
		
		session.dataTask(with: request) { _, _, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			print("Success")
			self.initData() // 초기화
		}
		
		// 임시: 전체 알림이 성공한다면 한번 결합해보고 싶네요. 제가 원래 쓰는 Network base code 입니다.
//		AF.request(NoticeRouter.postNotice(deviceToken: deviceToken, title: title, contents: contents))
//			.publishDecodable(type: [String].self)
//			.value() // 값만 가져오기
//			.receive(on: DispatchQueue.main)
//			.sink(receiveCompletion: {[weak self] in
//				guard case .failure(let error) = $0 else { return }
//				switch error.responseCode {
//				case 400: // 요청 에러 발생했을 때
//					break
//				case 500: // 서버의 내부적 에러가 발생했을 때
//					break
//				default:
//					break
//				}
//			}, receiveValue: { [weak self] receivedValue in
//				print(#file, #function, #line, "Success")
//				self.initData() // 초기화
//			})
//			.store(in: &subscription)
	}
}
