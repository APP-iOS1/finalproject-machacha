//
//  MStoreCellView.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI

struct MStoreCellView: View {
    var foodcart: FoodCart = FoodCart.getDummy()
    @StateObject var magazineVM: MagazineViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Spacer()
            HStack (alignment: .bottom, spacing: -1) {
   
                Image("store")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    
                    
                
                
                VStack {
                    Text(foodcart.name)
                        .font(.machachaTitleBold)
                        .padding(.top, 20)
                        .padding(.bottom, 0.1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text(foodcart.address)
                        .font(.machachaHeadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 15)
                }
                
                
                Spacer()
            } // 포장마차 이름
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(foodcart.imageId, id: \.self) { imageName in
                        
                        if let image = magazineVM.imageDict[imageName] {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                        } else { }

                    }
                }
                
            }
            Spacer()
        }
        .padding()
    }
}

struct MStoreCellView_Previews: PreviewProvider {
    static var previews: some View {
        MStoreCellView(magazineVM: MagazineViewModel())
    }
}
