//
//  ProfileFavoriteView.swift
//  Machacha
//
//  Created by geonhyeong on 2023/01/30.
//

import SwiftUI

struct ProfileFavoriteView: View {
	//MARK: Property wrapper
	@EnvironmentObject var profileVM: ProfileViewModel

    var body: some View {
		ScrollView {
			ForEach(profileVM.favoriteUser) { foodCart in
				Text(foodCart.name)
			}
		}
		.onAppear {
			Task {
				profileVM.favoriteUser = try await profileVM.fetchFavorite()
			}
		}
    }
}

struct ProfileFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFavoriteView()
    }
}
