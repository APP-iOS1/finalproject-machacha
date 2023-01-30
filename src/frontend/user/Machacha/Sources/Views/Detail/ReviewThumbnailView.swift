//
//  ReviewView.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/30.
//

import SwiftUI

struct ReviewThumbnailView: View {
    var selectedStore: FoodCart
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
        }
        .navigationTitle(selectedStore.name)
    }
}

struct ReviewThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewThumbnailView(selectedStore: FoodCart.getDummy())
    }
}
