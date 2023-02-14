//
//  NoticeRouter.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/13.
//

import Foundation
import Alamofire
import Combine

// URLRequestConvertible: Alamofire의 프로토콜로 'HTTP메서드, 헤더, 매개변수와 같은 초기 매개변수들'을 URLReqestConvertible로 캡슐화 하여 값을 전달
enum NoticeRouter: URLRequestConvertible {
	case postNotice(deviceToken: String, title: String, contents: String)
	
	private var baseURL: URL {
		switch self {
		case .postNotice:
			return URL(string: "\(APIConstants.url)")!
		}
	}
	
	private var method: HTTPMethod {
		switch self {
		case .postNotice:
			return .post
		}
	}
	
	private var path: String {
		switch self {
		case .postNotice: return "POST"
		}
	}
	
	private var headers: HTTPHeaders {
		var headers = HTTPHeaders()
		headers["Authorization"] = "key=\(APIConstants.serverKey)"
		headers["Content-Type"] = "application/json"

		return headers
	}
	
	private var parameters: Parameters {
		var params = Parameters()
		
		switch self {
		case let .postNotice(deviceToken, title, contents):
			params["to"] = deviceToken
			
			var notificationParams = Parameters()
			notificationParams["title"] = title
			notificationParams["body"] = contents
			
			params["notification"] = notificationParams
            params["data"] = ["user_name": "jungwoo"]
		}
		
		return params
	}
	
	func asURLRequest() throws -> URLRequest {
		let url = baseURL.appendingPathComponent(path)
		
		var request = URLRequest(url: url)
		request.method = method
		request.headers = headers
		
		switch self {
		case .postNotice:
			request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
		}
		
		return request
	}
}
