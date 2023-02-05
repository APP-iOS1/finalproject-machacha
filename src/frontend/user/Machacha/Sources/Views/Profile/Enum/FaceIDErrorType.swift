//
//  FaceIDErrorType.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/26.
//

import Foundation

// FaceID 권한 Error type
enum FaceIDError: Error, LocalizedError {
	case authenticationFailed // 사용자가 유효한 자격 증명을 제공하지 못했습니다.
	case userCancel // 사용자가 인증 대화 상자에서 취소 버튼을 탭했습니다.
	case userFallback // 사용자가 인증 대화 상자에서 폴백 버튼을 탭했지만 인증 정책에 사용할 수 있는 폴백이 없습니다.
	case systemCancel // 시스템이 인증을 취소했습니다.
	case passcodeNotSet // 장치에 암호가 설정되어 있지 않습니다.
	case biometryNotAvailable // 장치에서 생체 인식을 사용할 수 없습니다.
	case biometryNotPaired // 장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 없습니다.
	case biometryDisconnected // 장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 연결되지 않습니다.
	case biometryLockout // 실패한 시도가 너무 많아 생체 인식이 잠겼습니다.
	case biometryNotEnrolled // 사용자에게 등록된 생체 인식 ID가 없습니다.
	case appCancel // 앱이 인증을 취소했습니다
	case invalidContext // 컨텍스트가 이전에 비활성화되었습니다.
	case notInteractive // 필요한 인증 사용자 인터페이스를 표시할 수 없습니다.
	case watchNotAvailable // Apple Watch를 사용하여 인증하지 못했습니다.
	//		case .touchIDNotAvailable,touchIDNotEnrolled,touchIDLockout:
	case defult
	
	var errorDescription: String {
		switch self {
		case .authenticationFailed:
			return NSLocalizedString("사용자가 유효한 자격 증명을 제공하지 못했습니다", comment: "")
		case .userCancel:
			return NSLocalizedString("사용자가 인증 대화 상자에서 취소 버튼을 탭했습니다", comment: "")
		case .userFallback:
			return NSLocalizedString("사용자가 인증 대화 상자에서 폴백 버튼을 탭했지만 인증 정책에 사용할 수 있는 폴백이 없습니다", comment: "")
		case .systemCancel:
			return NSLocalizedString("시스템이 인증을 취소했습니다", comment: "")
		case .passcodeNotSet:
			return NSLocalizedString("장치에 암호가 설정되어 있지 않습니다", comment: "")
		case .biometryNotAvailable:
			return NSLocalizedString(" 장치에서 생체 인식을 사용할 수 없습니다", comment: "")
		case .biometryNotPaired:
			return NSLocalizedString("장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 없습니다", comment: "")
		case .biometryDisconnected:
			return NSLocalizedString("장치는 탈착식 액세서리를 사용하는 경우에만 생체 인식을 지원하지만 페어링된 액세서리는 연결되지 않습니다", comment: "")
		case .biometryLockout:
			return NSLocalizedString("실패한 시도가 너무 많아 생체 인식이 잠겼습니다", comment: "")
		case .biometryNotEnrolled:
			return NSLocalizedString("사용자에게 등록된 생체 인식 ID가 없습니다", comment: "")
		case .appCancel:
			return NSLocalizedString("앱이 인증을 취소했습니다", comment: "")
		case .invalidContext:
			return NSLocalizedString("컨텍스트가 이전에 비활성화되었습니다", comment: "")
		case .notInteractive:
			return NSLocalizedString("필요한 인증 사용자 인터페이스를 표시할 수 없습니다", comment: "")
		case .watchNotAvailable:
			return NSLocalizedString("Apple Watch를 사용하여 인증하지 못했습니다", comment: "")
		case .defult:
			return NSLocalizedString("알 수 없는 오류가 발생했습니다", comment: "")
		}
	}
}
