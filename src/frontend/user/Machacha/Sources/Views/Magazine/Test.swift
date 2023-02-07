//
//  Test.swift
//  Machacha
//
//  Created by Sue on 2023/02/01.
//

import SwiftUI

struct Test: View {
    
    @StateObject var magazineVM: MagazineViewModel
    var magazine: Magazine

    
    var body: some View {
        VStack {

            
            ForEach(magazineVM.magazineFoodCart) { foodcart in
//                Text("\(foodcart.imageId[0])")
                Text("foodcart: \(foodcart.name)")
                ForEach(foodcart.imageId, id: \.self) { imageName in
                    if let image = magazineVM.imageDict[imageName] {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 300, height: 270)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10.0)
                            .padding(.horizontal)
                    } else {

                    }

                }
//                Text("\(foodcartid)")
//                if let image = magazineVM.imageDict[foodcartid] {
//                    Image(uiImage: image)
//                        .resizable()
//                        .frame(width: 300, height: 270)
//                        .aspectRatio(contentMode: .fit)
//                        .cornerRadius(10.0)
//                        .padding(.horizontal)
//                } else {
//                    Text("비어ㅣㅇㅆ음")
//                }
            }
            
        }
        .onAppear {
            Task {
                magazineVM.magazineFoodCart = try await
                magazineVM.fetchFoodCarts(foodCartIds: magazine.foodCartId)
            }
//            print("TestView FoodCart: \(magazineVM.magazineFoodCart)")
        }
        //            ForEach(magazineVM.magazineFoodCart) { i in
        //                if let image = magazineVM.imageDict[i.id] {
        //                    Image(uiImage: image)
        //                        .resizable()
        //                        .frame(width: 300, height: 270)
        //                        .aspectRatio(contentMode: .fit)
        //                        .cornerRadius(10.0)
        //                        .padding(.horizontal)
        //                } else {
        //                    Text("비어ㅣㅇㅆ음")
        //                }
        //            }
    }
}


struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(magazineVM: MagazineViewModel(), magazine: Magazine.getDummy())
    }
}
