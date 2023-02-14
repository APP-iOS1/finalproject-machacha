//
//  ReportViewModel.swift
//  Machacha
//
//  Created by 이지연 on 2023/02/13.
//

import Foundation
import SwiftUI
import Firebase

class ReportViewModel: ObservableObject {
    
    @Published var reportShowToast: Bool = false
    let database = Firestore.firestore()
    
    // MARK: - 서버의 Report Collection에 Report 객체 하나를 추가하여 업로드하는 Method

    func addReport(report: Report) async {
        do {
            try await database.collection("Report")
                .document(report.id)
                .setData(["id": report.id,
                          "targetId": report.targetId,
                          "userId": report.userId,
                          "type": report.type,
                          "content": report.content,
                          "etc": report.etc,
                          "createdAt": report.createdAt
                         ])
        } catch {
            print("addReview error : \(error.localizedDescription)")
        }
    }
}
