//
//  HomeView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var selection: Int = 0
    @State var opacity: Double = 0.8
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            ScrollView {
                
                VStack(alignment: .leading) {
                    //광고 배너
                    ZStack {
                        TabView(selection: $selection) {
                            ForEach(0..<3, id: \.self) { i in
                                Image("advertise\(i+1)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Screen.maxWidth, height: 240)
                                    .tag(i)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        Text("\(selection+1) / 3")
                            .font(.machachaSubhead)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .background(Color(.gray).opacity(0.7))
                            .cornerRadius(30)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding([.bottom, .trailing])
                        
                    }
                    //                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .frame(height: 200)
                    .onReceive(timer) { t in
                        selection += 1
                        
                        if selection == 3 {
                            selection = 0
                        }
                    }
                    .animation(.easeIn, value: selection)
                    .padding(.bottom, 30)
                    .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                    
                    FoodCartListView(title: "맛잘알 마차챠의 PICK! 😮", subTitle: "이런 포장마차는 어떠세요?", foodCartList: foodCartViewModel.foodCarts1)
                    
                    FoodCartListView(title: "새로 오픈했어요! 😋", subTitle: "이런 포장마차는 어떠세요?", foodCartList: foodCartViewModel.foodCarts2)
                    
                    FoodCartVerticalListView(title: "요즘 인기있는 포장마차는", foodCartList: foodCartViewModel.foodCarts3)
                    
                }
                .padding(.bottom, 25)
            }
            .toolbar {
                //알림 이모지
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfileNotificationView(userNoti: profileViewModel.notification)
                    } label: {
                        Image(systemName: "bell.badge")
                            .foregroundColor(Color("Color3"))
                    }
                }
            }
        }
        .onAppear {
            foodCartViewModel.isLoading = true // progressview를 위해 선언
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
            Task {
                await foodCartViewModel.fetchFoodCarts()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { // 스켈레톤 View를 위해
                    foodCartViewModel.isLoading = false
                } // DispatchQueue
            }
        }
        //        .toolbarBackground(Color("Color3"), for: .navigationBar)
        //        .toolbarBackground(.visible, for: .navigationBar)
    }
}


// MARK: - extension View Deatil Component
extension HomeView {
    
    @ViewBuilder // 없어도 작동은 한다..명시적으로 쓴다
    private func FoodCartListView(title: String, subTitle: String, foodCartList: [FoodCart]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            //추천 멘트
            Text(title)
                .font(.machachaTitle3Bold)
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
            Text(subTitle)
                .font(.machachaSubhead)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(foodCartList) { foodCart in
                        NavigationLink {
                            DetailView(selectedStore: foodCart)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                //가게 대표 이미지
                                if let first = foodCart.imageId.first, let image = foodCartViewModel.imageDict[first] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 150, height: 170)
                                        .scaledToFit()
                                        .cornerRadius(7)
                                        .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                                }
                                
                                Text(foodCart.name)
                                    .lineLimit(1)
                                    .frame(width: 150, alignment: .leading)
                                    .foregroundColor(colorScheme == .dark ? Color(.white) : Color(.black))
                                    .font(.machachaHeadline)
                                    .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                                HStack(alignment: .bottom, spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .padding(.trailing, -3)
                                    Text("\(foodCart.favoriteCnt)")
                                    Image(systemName: "checkmark.seal.fill")
                                        .padding(.trailing, -3)
                                    Text("\(foodCart.visitedCnt)")
                                    Image(systemName: "square.and.pencil")
                                        .padding(.trailing, -3)
                                    Text("\(foodCart.reviewId.count)")
                                }
                                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                                .font(.footnote)
                                .foregroundColor(Color("Color3"))
                                .padding(.top, -5)
                            }
                        }
                        
                    }
                }
                .padding(.trailing)
            }
            .padding(.bottom, 30)
        }
        .padding(.leading)
    }
    
    @ViewBuilder // 없어도 작동은 한다..명시적으로 쓴다
    private func FoodCartVerticalListView(title: String, foodCartList: [FoodCart]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.machachaTitle3Bold)
                .padding(.bottom, 8)
                .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
            ForEach(foodCartList) { foodCart in
                NavigationLink {
                    DetailView(selectedStore: foodCart)
                } label: {
                    //가게 대표 이미지
                    if let first = foodCart.imageId.first, let image = foodCartViewModel.imageDict[first] {
                        Image(uiImage: image)
                            .resizable()
                            .padding(.bottom, 30)
                            .scaledToFill()
                            .frame(height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing)
                            .overlay {
                                ZStack {
                                    Color.black.opacity(0.3)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.trailing)
                                    Text(foodCart.name)
                                        .bold()
                                        .shadow(color: .black, radius: 9)
                                        .foregroundColor(.white)
                                        .font(.machachaHeadlineBold)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                        .padding([.leading, .bottom])
                                }
                            }
                            .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
                    }
                }
            }
        }
        .padding(.leading)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FoodCartViewModel())
            .environmentObject(ProfileViewModel())
    }
}
