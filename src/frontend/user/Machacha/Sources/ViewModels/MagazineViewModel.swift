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
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    // 정렬 기준: 인덱스를 두던가, createdAt 기준으로 하던가
    func fetchMagazines() {
        database.collection("Magazine")
            .getDocuments { (snapshot, error) in
                self.magazines.removeAll()
                //                self.imageDict.removeAll() // 얘도 비워야할 것 같음...
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        
                        let docData = document.data()
                        
                        let thumbTitle: String = docData["thumbTitle"] as? String ?? ""
                        let thumbnail: String = docData["thumbnail"] as? String ?? ""
                        let editorPickTitle: String = docData["editorPickTitle"] as? String ?? ""
                        let subTitle: String = docData["subTitle"] as? String ?? ""
                        let comment: String = docData["comment"] as? String ?? ""
                        let foodCartId: [String] = docData["foodCartId"] as? [String] ?? []
                        let updatedAt: Timestamp = docData["updatedAt"] as! Timestamp
                        let createdAt: Timestamp = docData["createdAt"] as! Timestamp
                        let show: Bool = docData["show"] as? Bool ?? false

                        let magazine: Magazine = Magazine(id: id, thumbTitle: thumbTitle, thumbnail: thumbnail, editorPickTitle: editorPickTitle, subTitle: subTitle, comment: comment, foodCartId: foodCartId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue(), show: show)
                        
                        self.magazines.append(magazine)
                    }
                }
            }
    }
    
    func fetchFoodCarts(foodCartIds: [String]) {
        
        for footCardID in foodCartIds {
            database.collection("FoodCart").document(footCardID).getDocument { [self] (snapshot, error) in
                self.imageDict.removeAll()
                self.magazineFoodCart.removeAll()
                if let snapshot {
                    
                    let data = snapshot.data()!
                    
                    let id = data["id"] as? String ?? ""
                    let name: String = data["name"] as? String ?? ""
                    let region: String = data["region"] as? String ?? ""
                    let address: String = data["address"] as? String ?? ""
                    let geoPoint: GeoPoint = data["geoPoint"] as! GeoPoint
                    let imageId: [String] = data["imageId"] as? [String] ?? []
                    let grade: Double = data["grade"] as? Double ?? 0
                    let visitedCnt: Int = data["visitedCnt"] as? Int ?? 0
                    let favoriteCnt: Int = data["favoriteCnt"] as? Int ?? 0
                    let reportCnt: Int = data["reportCnt"] as? Int ?? 0
                    let menu: [String: Int] = data["menu"] as? [String: Int] ?? [:]
                    let bestMenu: Int = data["bestMenu"] as? Int ?? 0
                    let paymentOpt: [Bool] = data["paymentOpt"] as? [Bool] ?? []
                    let openingDays: [Bool] = data["openingDays"] as? [Bool] ?? []
                    let reviewId: [String] = data["reviewId"] as? [String] ?? []
                    let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                    let createdAt: Timestamp = data["createdAt"] as! Timestamp
                    let registerId: String = data["registerId"] as? String ?? ""
                    
                    // fetch image set
                    // imageId : ["test.jpg"]
                    for imageName in imageId {
                        self.fetchImage(foodCartId: id, imageName: imageName)
                        // footCardId :  InzqNwgl15TytWNOdIZz
                        // imageName : test.jpg
                    }
                    
                    let foodCart: FoodCart = FoodCart(id: id, createdAt: createdAt.dateValue(), updatedAt: updatedAt.dateValue(), geoPoint: geoPoint, region: region, name: name, address: address, visitedCnt: visitedCnt, favoriteCnt: favoriteCnt, paymentOpt: paymentOpt, openingDays: openingDays, menu: menu, bestMenu: bestMenu, imageId: imageId, grade: grade, reportCnt: reportCnt, reviewId: reviewId, registerId: registerId)
                    
                    self.magazineFoodCart.append(foodCart)
                    print("FoodCart: \(magazineFoodCart)")
                }
            }
        }

    }
    
    // imageName : imageID
    func fetchImage(foodCartId: String, imageName: String) {
        let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.imageDict[imageName] = image
                // imageDict[test.jpg] = UIImage
            }
        }
    }
}
