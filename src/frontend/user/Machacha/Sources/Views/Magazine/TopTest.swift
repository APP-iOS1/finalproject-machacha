//
//  TopTest.swift
//  Machacha
//
//  Created by Sue on 2023/02/03.
//

import SwiftUI

struct TopTest: View {
    
    @StateObject var magazineVM = MagazineViewModel()
//    var foodcartTest: FoodCart = FoodCart.getDummy()
    
    var body: some View {
        NavigationStack {
            ForEach(magazineVM.magazineFoodCart) {foodcart in
                Text("1")
            }
            
            ForEach(magazineVM.magazines) { magazine in
                // CourseItem 각각의 카드들
                // course : 각각의 Course()
                NavigationLink {
                    Test(magazineVM: magazineVM, magazine: magazine)
                    
                } label: {
                    Text("\(magazine.title)")
                    
                }

                
                
            }
        }
        .onAppear {
            Task {
                magazineVM.magazines = try await magazineVM.fetchMagazines()
            }
        }
        
        
    }
}

struct TopTest_Previews: PreviewProvider {
    static var previews: some View {
        TopTest()
    }
}
