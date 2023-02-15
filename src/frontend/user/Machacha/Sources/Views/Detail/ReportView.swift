//
//  ReportView.swift
//  Machacha
//
//  Created by 이지연 on 2023/02/06.
//

import SwiftUI

struct ReportView: View {
    var commentReportList = ["불법정보가 포함 되어있어요.", "영리 목적 정보가 포함 되어있어요.","같은 내용이 도배 되어있어요.", "선정적인 단어가 포함 되어있어요", "욕설/인신공격이 포함되어있어요.", "기타 정보가 있어요."]
    var storeReportList = ["문 닫은 포장마차에요.", "포장마차 주소가 틀려요.", "위치표시가 틀려요.", "휴무일 정보가 틀려요.", "메뉴 정보가 틀려요.", "기타 정보가 있어요."]
    @State private var checkArr = Array(Array(repeating: false, count: 6))
    @State private var text = ""
    @FocusState private var isInFocusText: Bool
    @StateObject var reportViewModel: ReportViewModel
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @Environment(\.colorScheme) var colorScheme // 다크모드일 때 색 설정 변경을 위해 선언
    @Environment(\.dismiss) var dismiss
    var reportType: Int
    var targetId: String
    var userId: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("bgColor")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .leading, spacing: 7) {
                        
                        if reportType == 0 { //가게 정보 신고
                            ForEach(storeReportList.indices, id: \.self) { idx in
                                HStack {
                                    Text(storeReportList[idx])
                                    Spacer()
                                    Button {
                                        checkArr[idx].toggle()
                                    } label: {
                                        checkArr[idx] ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
                                    }
                                    .foregroundColor(Color("Color3"))
                                    .font(.system(size: 20))
                                }
                                Divider()
                                    .padding(.vertical, 5)
                            } //ForEach
                        } else if reportType == 1 { //댓글 신고
                            ForEach(commentReportList.indices, id: \.self) { idx in
                                HStack {
                                    Text(commentReportList[idx])
                                    Spacer()
                                    Button {
                                        checkArr[idx].toggle()
                                    } label: {
                                        checkArr[idx] ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
                                    }
                                    .foregroundColor(Color("Color3"))
                                    .font(.system(size: 20))
                                }
                                Divider()
                                    .padding(.vertical, 5)
                            }
                        }
                        
                        
                        ZStack {
                            if text.isEmpty {
                                TextEditor(text: .constant("기타 사유를 입력해주세요."))
                                    .foregroundColor(.gray)
                                    .disabled(true)
                                    .scrollContentBackground(.hidden) // HERE
                                    .background(colorScheme == .dark ? Color("cellColor") : Color("bgColor"))
                            }
                            TextEditor(text: $text)
                                .focused($isInFocusText)
                                .opacity(text.isEmpty ? 0.25 : 1)
                        }
                        .padding([.leading, .trailing])
                        .scrollContentBackground(.hidden) // HERE
                        .background(colorScheme == .dark ? Color("cellColor") : Color("bgColor"))
                        .frame(height: 150)
                        .padding(.top, 10)
                        .onTapGesture {
                            checkArr[5] = true
                        }
                        
                        Spacer()
                        
                        
                    }//VStack
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                } //VStack
            }
            .onTapGesture { // 키보드가 올라왔을 때 다른 화면 터치 시 키보드가 내려감
                self.endTextEditing()
            }
            .navigationBarTitle("신고하기", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        if reportType == 0 {
                            foodCartViewModel.isShowingReportSheet.toggle()
                        } else if reportType == 1 {
                            reviewViewModel.isShowingReportSheet.toggle()
                        }
                        Task {
                            let report = Report(id: UUID().uuidString, targetId: targetId, userId: userId, type: reportType, content: checkArr, etc: text, createdAt: Date())
                            await reportViewModel.addReport(report: report)
                            reportViewModel.reportShowToast = true
                        }
                    } label: {
                        Text("제출")
                            .font(.machachaHeadline)
                            .foregroundColor(checkArr == [false, false, false, false, false, false] ? Color(.gray) : Color("Color3"))
                    }
                    .disabled(checkArr == [false, false, false, false, false, false] ? true : false)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.machachaHeadline)
                            .foregroundColor(colorScheme == .dark ? Color(.white) : Color(.black))
                    }
                }
            }
        }//NavigationStack
    }
}

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView(reportType: 1, targetId: "", userId: "")
//    }
//}
