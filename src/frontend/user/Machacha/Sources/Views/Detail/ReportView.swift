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
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @Environment(\.colorScheme) var colorScheme // 다크모드일 때 색 설정 변경을 위해 선언
    @Environment(\.dismiss) var dismiss
    var reportType: Int
    var isdisable: Bool {
        return text == "" || checkArr == [false, false, false, false, false, false] ? true : false
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 7) {
//                    Text("신고하기")
//                        .font(.machachaTitle2Bold)
//                        .padding(.bottom, 30)
                    if reportType == 1 { //가게 정보 신고
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
                    } else if reportType == 2 { //댓글 신고
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
                    
                    Spacer()
                    
                    
                }//VStack
                .padding(.horizontal, 20)
                .padding(.top, 30)
            } //VStack
            .navigationBarTitle("신고하기", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        if reportType == 1 {
                            foodCartViewModel.isShowingReportSheet.toggle()
                        } else if reportType == 2 {
                            reviewViewModel.isShowingReportSheet.toggle()
                        }
                    } label: {
                        Text("제출")
                            .font(.machachaHeadline)
                            .foregroundColor(text == "" || checkArr == [false, false, false, false, false, false] ? Color(.gray) : Color(.black))
                    }
                    .disabled(text == "" || checkArr == [false, false, false, false, false, false] ? true : false)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.machachaHeadline)
                            .foregroundColor(.black)
                    }
                }
            }
        }//NavigationStack
    }
}

//// texteditior placeholder와 backgroundcolor 적용
//struct CustomTextEditor: View {
//    let placeholder: String
//    @Binding var text: String
//    let internalPadding: CGFloat = 5
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            if text.isEmpty  {
//                Text(placeholder)
//                    .foregroundColor(Color.primary.opacity(0.25))
//                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
//                    .padding(internalPadding)
//            }
//            TextEditor(text: $text)
//                .padding(internalPadding)
//        }
//        .onAppear {
//            UITextView.appearance().backgroundColor = .clear
//        }
//        .onDisappear {
//            UITextView.appearance().backgroundColor = nil
//        }
//    }
//}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(reportType: 1)
    }
}
