//
//  StoreInformView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import SwiftUI

struct StoreInformView: View {
    var selectedStore: FoodCart
    var dayArr = ["월", "화", "수", "목", "금", "토", "일"]
    var paymentArr = ["현금", "계좌이체", "카드"]
    @Binding var opacity: Double
    @EnvironmentObject var foodCartViewModel: FoodCartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()
                .padding(.vertical, 15)
            HStack {
                Image(systemName:"house")
                Text(selectedStore.address)
                
            }
            .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
            .padding(.leading, -3)
  
            HStack {
                Image(systemName:"clock")
                ForEach(dayArr.indices, id: \.self) { day in
                    Text(dayArr[day])
                        .padding(6)
                        .overlay {
                            Circle()
                                .opacity(0.1)
                        }
                        .foregroundColor(selectedStore.openingDays[day] ?
                                                 Color("Color3") : Color(.gray))
                }
            }
            .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
            HStack {
                Image(systemName:"creditcard")
                    .resizable()
                    .frame(width: 17, height: 15)
                ForEach(paymentArr.indices, id: \.self) { payment in
                    Text(paymentArr[payment])
                        .padding(6)
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .opacity(0.1)
                        }
                        .foregroundColor(selectedStore.paymentOpt[payment] ?
                                                 Color("Color3") : Color(.gray))
                }
            }
            .setSkeletonView(opacity: opacity, shouldShow: foodCartViewModel.isLoading)
        }//VStack
        .font(.machachaHeadline)
    }//body
}

//struct StoreInformView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreInformView(selectedStore: FoodCart.getDummy())
//    }
//}

