//
//  FoodCartMenuView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import SwiftUI

struct FoodCartMenuView: View {
    var selectedStore: FoodCart
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Divider()
                .padding(.vertical, 15)
            HStack {
                Text("메뉴")
                Text("\(selectedStore.menu.count)")
                    .foregroundColor(Color("Color3"))
            }
            .font(.machachaTitle2)
            .padding(.bottom, 15)
            .bold()
            

        }
    }
}

struct FoodCartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCartMenuView(selectedStore: FoodCart.getDummy())
    }
}
