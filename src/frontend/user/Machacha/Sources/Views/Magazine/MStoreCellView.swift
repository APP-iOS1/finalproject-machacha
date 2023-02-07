//
//  MStoreCellView.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI

struct MStoreCellView: View {
    var foodcart: FoodCart
    @StateObject var magazineVM: MagazineViewModel
    
    var body: some View {
        HStack{
            VStack (alignment: .leading) {

                // MARK: - 포장마차 이름, 위치
                HStack (alignment: .bottom, spacing: -0.6) {

                    Image("store")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100, alignment: .leading)


                    VStack (alignment: .leading) {
                        Text(foodcart.name)
                            .font(.machachaTitle2Bold)
//                            .font(.machachaTitle2Bold)
//                            .padding(.top, 20)
                            .padding(.bottom, 0.1)
                            


                        Text(foodcart.address)
                            .font(.machachaSubhead)
                            .foregroundColor(.gray)

                            .padding(.bottom, 12.1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                } //hstack


                
                //MARK: - 포장마차 사진들
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(foodcart.imageId, id: \.self) { imageName in
                            
                            if let image = magazineVM.imageDict[imageName] {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                            } else {
                                
                            }
                            
                        }
                    }
                    
                } //scrollview
                .padding(.horizontal, 7)
            }
        }//hstack
        .padding(.horizontal, 10)
    }//body
}

struct MStoreCellView_Previews: PreviewProvider {
    static var previews: some View {
        MStoreCellView(foodcart: FoodCart.getDummy(), magazineVM: MagazineViewModel())
        
    }
}
