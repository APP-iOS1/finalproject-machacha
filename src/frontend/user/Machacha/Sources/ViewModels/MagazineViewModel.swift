//
//  MagazineViewModel.swift
//  Machacha
//
//  Created by Sue on 2023/02/01.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage



class MagazineViewModel: ObservableObject {
    
    @Published var magazines: [Magazine] = []
    @Published var magazineFoodCart: [FoodCart] = []
    @Published var imageDict: [String : UIImage] = [:]
    @Published var isLoading = false
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    func fetchMagazines() async throws -> [Magazine] {
        var magazines = [Magazine]()
        
        let magazineSnapshot = try await  database.collection("Magazine").getDocuments()
        
        for magazine in magazineSnapshot.documents {
            let docData = magazine.data()
            
            let id: String = docData["id"] as? String ?? ""
            let title: String = docData["title"] as? String ?? ""
            let subtitle: String = docData["subtitle"] as? String ?? ""
            let editorPickTitle: String = docData["editorPickTitle"] as? String ?? ""
            let editorCommemt: String = docData["editorCommemt"] as? String ?? ""
            let image: String = docData["image"] as? String ?? ""
            let background: String = docData["background"] as? String ?? ""
            let foodCartIds: [String] = docData["foodCartId"] as? [String] ?? []
            let createdAt: Timestamp = docData["createdAt"] as! Timestamp
            let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
            
            magazines.append(Magazine(id: id, title: title, subtitle: subtitle, editorPickTitle: editorPickTitle, editorCommemt: editorCommemt, image: image, background: background, foodCartId: foodCartIds, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue()))
            
        }
        print("fetched Magazines: \(magazines)")
        return magazines
    }
    
    func fetchFoodCarts(foodCartIds: [String]) async throws -> [FoodCart] {
        var foodcarts = [FoodCart]()
        
        for foodcartID in foodCartIds {
            let foodcartSnapshot = try await database.collection("FoodCart").document(foodcartID).getDocument()
            
            let docData = foodcartSnapshot.data()!
            
            let id: String = docData["id"] as? String ?? ""
            let region: String = docData["region"] as? String ?? ""
            let name: String = docData["name"] as? String ?? ""
            let address: String = docData["address"] as? String ?? ""
            let visitedCnt: Int = docData["visitedCnt"] as? Int ?? 0
            let favoriteCnt: Int = docData["favoriteCnt"] as? Int ?? 0
            let paymentOpt: [Bool] = docData["paymentOpt"] as? [Bool] ?? []
            let openingDays: [Bool] = docData["openingDays"] as? [Bool] ?? []
            let menu: [String: Int] = docData["menu"] as? [String: Int] ?? [:]
            let bestMenu: Int = docData["bestMenu"] as? Int ?? 0
            let imageId: [String] = docData["imageId"] as? [String] ?? []
            let grade: Double = docData["grade"] as? Double ?? 0.0
            let reportCnt: Int = docData["reportCnt"] as? Int ?? 0
            let reviewId: [String] = docData["reviewId"] as? [String] ?? []
            let registerId: String = docData["registerId"] as? String ?? ""
            let geoPoint: GeoPoint = docData["geoPoint"] as! GeoPoint
            let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
            let createdAt: Timestamp = docData["createdAt"] as! Timestamp
            
            // fetch image set
            // imageId : ["test.jpg"]
            for imageName in imageId {
                try await self.fetchImage(foodCartId: id, imageName: imageName)
//                self.fetchImage(foodCartId: id, imageName: imageName)
                // footCardId :  InzqNwgl15TytWNOdIZz
                // imageName : test.jpg
            }
            
            foodcarts.append(FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId))
            
        }
        
        return foodcarts
    }
    

    @MainActor
    func fetchImage(foodCartId: String, imageName: String) async throws {
        do {
            let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
            let data = try await ref.data(maxSize: 1 * 1024 * 1024)
            let image = UIImage(data: data)
            self.imageDict[imageName] = image
        } catch {
            print("Magazine fetchImage error : \(error.localizedDescription)")
        }
    }
    
    // imageName : imageID
//    func fetchImage1(foodCartId: String, imageName: String) {
//        let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("매거진 error while downloading image\n\(error.localizedDescription)")
//                return
//            } else {
//                let image = UIImage(data: data!)
//                self.imageDict[imageName] = image
//                // imageDict[test.jpg] = UIImage
//            }
//        }
//    }
    
    
    
//    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
//    func fetchImage(foodCartId: String, imageName: String) async throws -> UIImage {
//        do {
//            let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
//
//            let data = try await ref.data(maxSize: 1 * 1024 * 1024)
//
//            return UIImage(data: data)!
//        } catch {
//            print("fetchFoodCarts error: \(error.localizedDescription)")
//        }
//    }
}
