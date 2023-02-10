//
//  TopTest.swift
//  Machacha
//
//  Created by Sue on 2023/02/03.
//

import SwiftUI
import Kingfisher

struct TopTest: View {
    
    @StateObject var magazineVM = MagazineViewModel()
//    var foodcartTest: FoodCart = FoodCart.getDummy()
    let urlString = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBX6OIA69w4mGtEkIqqd3htZL05QjcEGqPrJutfiXW&s"
    
    var body: some View {
        VStack {
            KFImage(URL(string: urlString))
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(20)
                
        }
        
    }
}

struct TopTest_Previews: PreviewProvider {
    static var previews: some View {
        TopTest()
    }
}
