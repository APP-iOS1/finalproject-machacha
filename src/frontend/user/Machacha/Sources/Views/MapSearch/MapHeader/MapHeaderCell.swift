//
//  MapHeaderCell.swift
//  Machacha
//
//  Created by Park Jungwoo on 2023/01/30.
//

import SwiftUI

struct MapHeaderCell: View {
    let cellList = ["bbungbread", "fishcake", "sweetpotato", "tteokboki", "store"]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(cellList, id: \.self) { item in
                    MapHeaderTagCell(image: item)
                }
            }
        }
    }
}

struct MapHeaderCell_Previews: PreviewProvider {
    static var previews: some View {
        MapHeaderCell()
    }
}
