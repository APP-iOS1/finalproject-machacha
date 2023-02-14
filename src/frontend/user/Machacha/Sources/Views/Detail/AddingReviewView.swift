//
//  ReviewAddingView.swift
//  Machacha
//
//  Created by 이지연 on 2023/02/07.
//

import SwiftUI
import UIKit
import PhotosUI
import AlertToast


struct AddingReviewView: View {

    @State private var starArr = Array(repeating: false, count: 5)
    @State var grade : Double = 0 // 별점
    @State var text = ""
    // selecting Multiple Photos
    @State private var selectedItems: [PhotosPickerItem] = [] // 선택한 사진을 보관할 상태 변수
    @State private var selectedPhotosData: [Data] = []
    var images: [UIImage]  { //addimages할때 UIImage
        var result: [UIImage] = []
        if !selectedPhotosData.isEmpty {
            for photoData in selectedPhotosData {
                if let image = UIImage(data: photoData) {
                    result.append(image)
                }
            }
        }
        return result
    }
    @Environment(\.colorScheme) var colorScheme // 다크모드일 때 색 설정 변경을 위해 선언
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @FocusState private var isInFocusText: Bool
    @Binding var showToast: Bool
    var selectedStore: FoodCart
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    //별점
                    HStack(spacing: 15){
                        ForEach(0..<5,id: \.self){ index in
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(Double(index) < grade ? Color("Color3") : Color.secondary)
                                .frame(width: 44, height: 44)
                                .onTapGesture {
                                    grade = Double(index+1)
                                }
                        }
                    } //HStack
                    .padding(.vertical, 40)
                    
                    VStack {
                        //후기 Text
                        Text("상세한 후기를 써주세요.")
                            .font(.machachaTitle3Bold)
                        ZStack {
                            if text.isEmpty {
                                TextEditor(text: .constant("작성 내용은 마이페이지와 장소 리뷰에 노출되며 매장주를 포함한 다른 사용자들이 볼 수 있으니, 서로를 배려하는 마음을 담아 작성 부탁드립니다."))
                                    .lineSpacing(8)
                                    .foregroundColor(.gray)
                                    .disabled(true)
                                    .scrollContentBackground(.hidden) // HERE
                                    .background(colorScheme == .dark ? Color("cellColor") : Color("bgColor"))
                            }
                            TextEditor(text: $text)
                            //                            .focused($isInFocusText)
                                .opacity(text.isEmpty ? 0.25 : 1)
                        } //ZStack
                        .keyboardType(.default)
                        .focused($isInFocusText)
                        .padding([.leading, .trailing])
                        .scrollContentBackground(.hidden) // HERE
                        .background(colorScheme == .dark ? Color("cellColor") : Color("bgColor"))
                        .frame(height: 300)
                        .padding(.vertical, 10)
                        
                        // 최대 5장의 사진을 지원
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                            HStack(alignment: .center) {
                                Image(systemName: "camera")
                                    .font(.machachaTitle2)
                                Text("사진 첨부하기")
                                    .foregroundColor(.black)
                                    .font(.machachaCallout)
                            }
                            .foregroundColor(.black)
                            .frame(width: 350, height: 60)
                            .cornerRadius(10)
                            .border(.black)
                        }
                        .padding(.bottom, 10)
                        
                        // 선택된 사진 나열
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                //Spacer()
                                ForEach(selectedPhotosData.indices, id: \.self) { photoData in
                                    if let image = UIImage(data: selectedPhotosData[photoData]) {
                                        
                                        Image(uiImage: image)
                                            .resizable()
                                            .cornerRadius(5)
                                            .frame(width: 120, height: 120)
                                            .aspectRatio(contentMode: .fit)
                                            .overlay {
                                                Button {
                                                    selectedPhotosData.remove(at: photoData)
                                                } label: {
                                                    Image(systemName: "x.circle.fill")
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                        .padding(.trailing, 5)
                                                        .padding(.top, 5)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        Spacer() //왼쪽 정렬을 위해 사용
                                    }
                                }//FoEeach
                                //Spacer()
                            }//HStack
                        }//ScrollView
                        .padding(.leading, 5)
                        .padding(.bottom, 30)
                    }//VStack
                    .padding(.horizontal, 20)
                }
            }//ScrollView
            .onTapGesture { // 키보드가 올라왔을 때 다른 화면 터치 시 키보드가 내려감
                self.endTextEditing()
            }
            .navigationBarTitle("리뷰 작성", displayMode: .inline)
            .toolbar {
                //뒤로가기
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.machachaHeadline)
                            .foregroundColor(colorScheme == .dark ? Color(.white) : Color(.black))
                    }
                }
                //리뷰 등록
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        reviewViewModel.isLoading = true
                        if let user = profileViewModel.currentUser?.id {
                            let review: Review = Review(id: UUID().uuidString, reviewer: user, foodCartId: selectedStore.id, grade: grade, description: text, imageId: [], updatedAt: Date(), createdAt: Date())
                            reviewViewModel.addReview(review: review, images: images, foodCart: selectedStore)
                            Task {
                                reviewViewModel.reviews = try await reviewViewModel.fetchReviews(foodCartId: selectedStore.id)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { // 사진 등록 시간
                                    reviewViewModel.isLoading = false
                                    foodCartViewModel.isShowingReviewSheet.toggle()
                                }
                            }
                        }
                        showToast = true
                    } label: {
                            Text("등록")
                                .font(.machachaHeadlineBold)
                                .foregroundColor(text.count > 0 && text != "" ? Color("Color3") : Color(.lightGray))
                    }
                    .disabled(text.count > 0 ? false : true)
                }
            }
            .toast(isPresenting: $reviewViewModel.isLoading){
                //리뷰 등록 시  ProgressView 작동
                AlertToast(type: .loading)
            }
            //선택된 이미지를 변수에 저장
            .onChange(of: selectedItems) { newItems in
                for newItem in newItems {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            selectedPhotosData.append(data)
                        }
                    }
                    
                }
            }
            //리뷰 등록
        }
    }

}

//struct AddingReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddingReviewView()
//    }
//}
