//
//  MagazineView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/17.
//

import SwiftUI

struct MagazineView: View {
    @StateObject var magazineVM = MagazineViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(magazineVM.magazines) { magazine in
               
                    NavigationLink {
                        Test(magazineVM: magazineVM, magazine: magazine)

                    } label: {
//                        Text("\(magazine.thumbTitle)")
                    }


                }
            }
        }
        .onAppear {
            magazineVM.fetchMagazines()
            
        }
    }
}

struct MagazineView_Previews: PreviewProvider {
    static var previews: some View {
        MagazineView()
    }
}
