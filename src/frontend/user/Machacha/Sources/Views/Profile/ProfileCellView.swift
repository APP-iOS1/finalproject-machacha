//
//  ProfileCellView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileCellView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel

	//MARK: Property
	let foodCart: FoodCart
	
    var body: some View {
		VStack {
			Text(foodCart.name)
		}
    }
}

struct ProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
		let profileVM = ProfileViewModel()
		
		ProfileCellView(foodCart: FoodCart.getDummy())
			.environmentObject(profileVM)
			.onAppear {
				profileVM.currentUser = User.getDummy()
			}
    }
}
