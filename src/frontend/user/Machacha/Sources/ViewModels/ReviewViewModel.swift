//
//  ReviewViewModel.swift
//  Machacha
//
//  Created by 이지연 on 2023/01/31.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class ReviewViewModel: ObservableObject {
    
    @Published var reviews: [Review] = []
    @Published var twoReviews: [Review] = []
    @Published var imageDict: [String : UIImage] = [:]
    @Published var isLoading: Bool = false
    @Published var reviewer: User = User(id: "", isFirstLogin: true, email: "", name: "", profileId: "", favoriteId: [], visitedId: [], updatedAt: Date(), createdAt: Date())
    @Published var reviewerImageDict: [String : UIImage] = [:]
    @Published var isShowingAlert = false
    @Published var isShowingReportSheet = false
    
    let database = Firestore.firestore()
    let storage = Storage.storage()
    
    
    // MARK: - 서버에서 가게에 맞는 Review Collection의 데이터들을 불러오는 Method
    @MainActor
    func fetchReviews(foodCartId: String) async {
        do {
            let querysnapshot = try await database.collection("Review")
                .whereField("foodCartId", isEqualTo: foodCartId)
                .getDocuments()
            self.reviews.removeAll()
            
            for document in querysnapshot.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let reviewer: String = data["reviewer"] as? String ?? ""
                let foodCartId: String = data["foodCartId"] as? String ?? ""
                let grade: Double = data["grade"] as? Double ?? 0
                let description: String = data["description"] as? String ?? ""
                let imageId: [String] = data["imageId"] as? [String] ?? []
                let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                let createdAt: Timestamp = data["createdAt"] as! Timestamp
                
                // fetch image set
                for imageName in imageId {
                    self.fetchImage(foodCartId: foodCartId, imageName: imageName)
                }
                
                let review: Review = Review(id: id, reviewer: reviewer, foodCartId: foodCartId, grade: grade, description: description, imageId: imageId, upadatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())
                
                reviews.append(review)
                
            }
        } catch {
            print("fetchReviews error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 서버에서 가게에 맞는 2개의 리뷰를 Review Collection의 데이터들을 불러오는 Method
    @MainActor
    func fetchTwoReviews(foodCartId: String) async {
        do {
            let querysnapshot = try await database.collection("Review")
                .whereField("foodCartId", isEqualTo: foodCartId)
                .limit(to: 2)
                .getDocuments()
            self.twoReviews.removeAll()
            
            for document in querysnapshot.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let reviewer: String = data["reviewer"] as? String ?? ""
                let foodCartId: String = data["foodCartId"] as? String ?? ""
                let grade: Double = data["grade"] as? Double ?? 0
                let description: String = data["description"] as? String ?? ""
                let imageId: [String] = data["imageId"] as? [String] ?? []
                let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                let createdAt: Timestamp = data["createdAt"] as! Timestamp
                
                // fetch image set
                for imageName in imageId {
                    self.fetchImage(foodCartId: foodCartId, imageName: imageName)
                }
                
                let review: Review = Review(id: id, reviewer: reviewer, foodCartId: foodCartId, grade: grade, description: description, imageId: imageId, upadatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())
                
                twoReviews.append(review)
            }
            print("twoReviews = \(twoReviews)")
        } catch {
            print("fetchTwoReviews error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func fetchImage(foodCartId: String, imageName: String) {
        let ref = storage.reference().child("images/\(foodCartId)/\(imageName)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("review image error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.imageDict[imageName] = image
            }
        }
    }
    
    // MARK: - 서버의 Storage에 이미지를 업로드하는 Method
    func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("images/\(name)") // 수현님께 경로 관련 질문
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
        
    }
    
    // MARK: - 서버의 Review Collection에 Review 객체 하나를 추가하여 업로드하는 Method
    func addReview(review: Review,  images: [UIImage] )  {
        
        // create image name list
        var imgNameList: [String] = []
        
        // iterate over images
        for img in images {
            let imgName = UUID().uuidString //imgName: 이미지마다 id를 만들어줌
            imgNameList.append(imgName)
            uploadImage(image: img, name: (review.id + "/" + imgName)) // ? 경로 너무 어려움 수현님께 질문 2
        }
        // uploadImage 실행 다 끝나기 전에 113줄 동시에 실행될 수도 있음
        database.collection("Review")
            .document(review.id)
            .setData(["id": review.id,
                      "reviewer": review.reviewer,
                      "foodCartId": review.foodCartId,
                      "grade": review.grade,
                      "description": review.description,
                      "imageId": imgNameList, //[diary.id + "/" + imgName]
                      "upadatedAt": review.upadatedAt,
                      "createdAt": review.createdAt,
                     ])
        
    }
    
    
    
    // MARK: - 서버의 Diary Collection에서 Diary 객체 하나를 삭제하는 Method
    func removeDiary(review: Review) {
        database.collection("Review")
            .document(review.id).delete()
        
        
        // diary.images: [diary.id + "/" + imgName, diary.id + "/" + imgName ]
        // remove photos from storage
        for image in review.imageId {
            let imagesRef = storage.reference().child("images/\(review.foodCartId)/\(image)")
            imagesRef.delete { error in
                if let error = error {
                    print("Error removing image from storage\n\(error.localizedDescription)")
                } else {
                    print("images directory deleted successfully")
                }
            }
            
        }
    }
    
    @MainActor
    func fetchReviewer(userId: String) async {
        do {
            let querysnapshot = try await database.collection("User")
                .whereField("id", isEqualTo: userId)
                .getDocuments()

            for document in querysnapshot.documents {
                let data = document.data()

                let id: String = data["id"] as? String ?? ""
                let isFirstLogin: Bool = data["isFirstLogin"] as? Bool ?? false
                let email: String = data["email"] as? String ?? ""
                let name: String = data["name"] as? String ?? ""
                let profileId: String = data["profileId"] as? String ?? ""
                let favoriteId: [String] = data["favoriteId"] as? [String] ?? []
                let visitedId: [String] = data["visitedId"] as? [String] ?? []
                let updatedAt: Timestamp = data["updatedAt"] as! Timestamp
                let createdAt: Timestamp = data["createdAt"] as! Timestamp

                // fetch image set
                self.fetchReviewImage(userId: id, imageName: profileId)
                print("profileId : \(profileId)")

                reviewer = User(id: id, isFirstLogin: isFirstLogin, email: email, name: name, profileId: profileId, favoriteId: favoriteId, visitedId: visitedId, updatedAt: updatedAt.dateValue(), createdAt: createdAt.dateValue())
                print("imageDict : \(imageDict)")
            }
        } catch {
            print("fetchReviews error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func fetchReviewImage(userId: String, imageName: String) {
        print("userId = \(userId), imageName = \(imageName)")
        let ref = storage.reference().child("images/\(userId)/\(imageName)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("review image error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.reviewerImageDict[imageName] = image
            }
        }
    }
}
