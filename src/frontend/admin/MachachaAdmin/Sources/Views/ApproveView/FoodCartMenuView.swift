//
//  FoodCartMenuView.swift
//  MachachaAdmin
//
//  Created by geonhyeong on 2023/02/15.
//

import SwiftUI

struct FoodCartMenuView: View {
	var selectedStore: FoodCart
	@Binding var opacity: Double
	@StateObject var foodCartViewModel: FoodCartViewModel

	var body: some View {
		
		VStack(alignment: .leading) {
			Divider()
				.padding(.vertical, 15)
			HStack {
				Text("메뉴")
				Text("\(selectedStore.menu.count)")
					.foregroundColor(Color("Color3"))
			}
			.font(.system(size: 22))
			.bold()
			.padding(.bottom, 15)
			
			ForEach(selectedStore.menu.sorted(by: >), id: \.key) { menu, price in
				HStack {
					Text(menu)
					Spacer()
					Text("￦\(price)")
				}
				.padding(.trailing, 14)
				.padding(.bottom, 2)
				.font(.system(size: 17))
			} //ForEach
		}
	}
}

//struct FoodCartMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodCartMenuView(selectedStore: FoodCart.getDummy())
//    }
//}
