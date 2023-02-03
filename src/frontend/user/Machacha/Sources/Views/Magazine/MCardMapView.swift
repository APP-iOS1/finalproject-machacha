//
//  MCardMapView.swift
//  Machacha
//
//  Created by Sue on 2023/02/03.
//

import SwiftUI

struct MCardMapView: View {
    
    @StateObject var model: Model
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(.secondary)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(30)
            
            Text("매거진 맵 뷰")
        }
    }//body
    
//    var button: some View {
//        Button {
//            dismiss()
//        } label: {
//            Image(systemName: "xmark")
//                .font(.body.weight(.bold))
//                .foregroundColor(.secondary)
//                .padding(8)
//                .background(.ultraThinMaterial, in: Circle())
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//        .padding(30)
//        .ignoresSafeArea()
//    }
}

struct MCardMapView_Previews: PreviewProvider {
    static var previews: some View {
        MCardMapView(model: Model())
    }
}
