//
//  FaceIDViewModel.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/26.
//

import Foundation
import LocalAuthentication

class FaceIDViewModel: ObservableObject {
	//MARK: Property Wrapper
	@Published var biometricType: LABiometryType = .none
	@Published var showErrorAlert = false
	@Published var showErrorAlertTitle = "FaceID 접근 오류"
	@Published var showErrorAlertMessage = "Error"
	
	//MARK: Property
	fileprivate var context: LAContext?
	
	init() {
		context = LAContext()
		context?.localizedCancelTitle = "취소" // 생체 인식 인증 실패 시 묻습니다. 기본값은 취소입니다.
		context?.localizedFallbackTitle = "패스워드 사용" // 생체 인식 인증 실패 시 묻습니다. 기본값은 비밀번호 입력입니다.
	}
	
	deinit { // 소멸자
		context = nil
	}
	
	// 권한 확인 & Face 스캔 시작
	@MainActor func authenticate() {
		context = LAContext()
		context?.localizedCancelTitle = "취소" // 첫 번째/두 번째 생체 인식 인증 실패 시 묻습니다. 기본값은 취소입니다.
		context?.localizedFallbackTitle = "확인" // 두 번째 생체 인식 인증 실패 시 묻습니다. 기본값은 비밀번호 입력입니다.

		if let context {
			let reason = "얼굴 인식이 어려워요"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [self] success, error in
				if success {
					print(#fileID, #function, #line, "Face ID 성공")
				} else if let error = error as? LAError {
					switch error.code {
					case .authenticationFailed:
						// 사용자가 유효한 자격 증명을 제공하지 못했습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.authenticationFailed.errorDescription
					case .userCancel:
						// 사용자가 인증 대화 상자에서 취소 버튼을 탭했습니다.
						showErrorAlert = false
						showErrorAlertMessage = FaceIDError.userCancel.errorDescription
					case .userFallback:
						// 사용자가 인증 대화 상자에서 확인 버튼을 탭했지만 인증 정책에 사용할 수 있는 수단이 없습니다.
						showErrorAlert = false
						showErrorAlertMessage = FaceIDError.userFallback.errorDescription
					case .systemCancel:
						// 시스템이 인증을 취소했습니다.
						showErrorAlert = false
						showErrorAlertMessage = FaceIDError.systemCancel.errorDescription
					case .passcodeNotSet:
						// 장치에 암호가 설정되어 있지 않습니다.
						showErrorAlert = false
						showErrorAlertMessage = FaceIDError.passcodeNotSet.errorDescription
					case .biometryNotAvailable:
						// 장치에서 생체 인식을 사용할 수 없습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.biometryNotAvailable.errorDescription
					case .biometryNotPaired:
						// 장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 없습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.biometryNotPaired.errorDescription
					case .biometryDisconnected:
						// 장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 연결되지 않습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.biometryDisconnected.errorDescription
					case .biometryLockout:
						// 실패한 시도가 너무 많아 생체 인식이 잠겼습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.biometryLockout.errorDescription
					case .biometryNotEnrolled:
						// 사용자에게 등록된 생체 인식 ID가 없습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.biometryNotEnrolled.errorDescription
					case .appCancel:
						// 앱이 인증을 취소했습니다
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.appCancel.errorDescription
					case .invalidContext:
						// 컨텍스트가 이전에 비활성화되었습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.invalidContext.errorDescription
					case .notInteractive:
						// 필요한 인증 사용자 인터페이스를 표시할 수 없습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.notInteractive.errorDescription
					case .watchNotAvailable:
						// Apple Watch를 사용하여 인증하지 못했습니다.
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.watchNotAvailable.errorDescription
						// case .touchIDNotAvailable,touchIDNotEnrolled,touchIDLockout:
						// TODO: Apple은 iOS 11에서 더 이상 사용되지 않는 오류
					default:
						showErrorAlert = true
						showErrorAlertMessage = FaceIDError.defult.errorDescription
					}
				}
			}
		}
	}
}
