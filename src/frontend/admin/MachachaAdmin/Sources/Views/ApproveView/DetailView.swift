//
//  DetailView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct DetailView: View {
	var selectedStore: FoodCart
	@StateObject var foodCartViewModel = FoodCartViewModel()
	@State var isFavorited: Bool = false
	@State var isVisited: Bool = false
	@State var showToast = false
	@State var opacity: Double = 0.8
	var basicImages = ["bbungbread2", "sweetpotato2", "takoyaki", "beverage"]
	var count = 0

	var body: some View {
		ScrollView {
			VStack(alignment: .leading){
				ScrollView (.horizontal, showsIndicators: false) {
					HStack(alignment: .top) {
						if foodCartViewModel.imageDict.count > 0 {
							ForEach(0..<selectedStore.imageId.count, id: \.self) { index in
									if let image = foodCartViewModel.imageDict[selectedStore.imageId[index]] {
										Image(uiImage: image)
											.resizable()
											.frame(width: 200, height: 200)
											.aspectRatio(contentMode: .fit)
									}
								}//ForEach
								if selectedStore.imageId.count > 4, let image = foodCartViewModel.imageDict[selectedStore.imageId[4]] {
									NavigationLink {
										
									} label: {
										Image(uiImage: image)
											.resizable()
											.frame(width: 200, height: 200)
											.aspectRatio(contentMode: .fit)
											.overlay {
												Rectangle()
													.foregroundColor(.black)
													.opacity(0.5)
												Image(systemName: "plus")
													.resizable()
													.frame(width: 60, height: 60)
													.foregroundColor(.gray)
											}
									}
								}
						} else {
							ForEach(basicImages, id:\.self) { images in
								Rectangle()
									.frame(width: 200, height: 200)
									.foregroundColor(.gray)
									.overlay {
										Image(images)
											.resizable()
											.frame(width: 100, height: 100)
									}
 
							}
						}
					}//HStack
				}//ScrollView
				
				HStack {
					Text(selectedStore.name)
						.font(.system(size: 28))
						.lineLimit(3)
					Spacer()
					Text("★ \(String(format: "%.1f", selectedStore.grade))")
						.foregroundColor(Color("Color3"))
						.font(.system(size: 22))
						.bold()
						.padding(.trailing, 20)
				}
				.padding(.leading, 20)
				.padding(.top, 20)
				.padding(.bottom, 5)
				
				HStack(spacing: 5) {
					Image(systemName: "heart.fill")
					Text("\(selectedStore.favoriteCnt)")
						.padding(.trailing, 5)
					Image(systemName: "checkmark.seal.fill")
					Text("\(selectedStore.visitedCnt)")
				}
				.padding(.horizontal, 20)
				.foregroundColor(.gray)
				
				IconTabView(selectedStore: selectedStore, foodCartViewModel: foodCartViewModel, isFavorited: .constant(false), isVisited: .constant(false), opacity: $opacity) // 아이콘 4개
				StoreInformView(selectedStore: selectedStore, opacity: $opacity, foodCartViewModel: foodCartViewModel) // 가게정보
					.padding(.leading, 20)
				FoodCartMenuView(selectedStore: selectedStore, opacity: $opacity, foodCartViewModel: foodCartViewModel) // 메뉴 정보
					.padding(.leading, 20)
			}
			.onAppear {
				withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
					self.opacity = opacity == 0.4 ? 0.8 : 0.4
				}
			}
		}
		.navigationBarTitle("", displayMode: .inline)
	}
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(selectedStore: FoodCart.getDummy())
//            .environmentObject(FoodCartViewModel())
//            .environmentObject(ReviewViewModel())
//            .environmentObject(MapSearchViewModel())
//    }
//}
