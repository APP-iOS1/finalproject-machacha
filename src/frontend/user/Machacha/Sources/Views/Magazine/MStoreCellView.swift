//
//  MStoreCellView.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore
//import struct Kingfisher.KFImage


struct MStoreCellView: View {
    var foodcart: FoodCart2
    @StateObject var magazineVM: MagazineViewModel
    @Binding var isLoading: Bool
    @Binding var opacity: Double
    
//    @ViewBuilder
//    func KingFisherImageView(url: String) -> KFImage {
//        KFImage(
//            URL(string: url)
//        )
//            .onSuccess { result in
//                print("Image loaded succesfully ")
//            }
//            .onFailure { err in
//                print("failed to load image: \(err)")
//            }
//            .placeholder() {
//                Image(systemName: "hourglass")
//                    .font(.largeTitle)
//            }
//
//    }
    
    var body: some View {
        HStack{

            VStack (alignment: .leading) {
                
                // MARK: - 포장마차 이름, 위치
                HStack (alignment: .bottom, spacing: -0.6) {
                    
                    
                    Image("store")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100, alignment: .leading)
                    
                    
                    VStack (alignment: .leading) {
                        Text(foodcart.name)
                            .font(.machachaTitle2Bold)
                            .foregroundColor(Color("textColor"))
                        //                            .padding(.top, 20)
                            .padding(.bottom, 0.1)
                            
                        
                        
                        
                        Text(foodcart.address)
                            .font(.machachaSubhead)
                            .foregroundColor(Color("textColor2"))
                            .padding(.bottom, 12.1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Spacer()
                } //hstack
               
                
                /*
                 KFImage(url)
                 .placeholder {
                 // Placeholder while downloading.
                 Image(systemName: "arrow.2.circlepath.circle")
                 .font(.largeTitle)
                 .opacity(0.3)
                 }
                 .retry(maxCount: 3, interval: .seconds(5))
                 .onSuccess { r in
                 // r: RetrieveImageResult
                 print("success: \(r)")
                 }
                 .onFailure { e in
                 // e: KingfisherError
                 print("failure: \(e)")
                 }
                 */
                
                // url이 화면에 표시할 때 다운로드하고
                // 동시에 다운로드한 이미지를 메모리 & 디스크에 모두 저장
                // 동일한 URL을 설정하면 KFImage 캐시에서 로드됨
                
                
                
                
                //MARK: - 포장마차 사진들
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        // foodcart.imageId: [String]
                        // "IMG_2468.HEIC"
                        ForEach(foodcart.url, id: \.self) { urlString in
                            
//                            KingFisherImageView(url: urlString)
//                                .resizable()
//                                .frame(width: 120, height: 120)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            
                            KFImage(URL(string: urlString))
                                .placeholder() {
                                    Image(systemName: "hourglass")
                                        .font(.largeTitle)
                                }
                                .onSuccess { result in
                                    print("Image loaded succesfully ")
                                }
                                .onFailure { err in
                                    print("failed to load image: \(err)")
                                }
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }//foreach
                    }//scrollview
                }
            }
        }//hstack
        .padding(.horizontal, 10)
    }
}

struct MStoreCellView_Previews: PreviewProvider {
    static var previews: some View {
        MStoreCellView(
            foodcart: FoodCart2(id: "CE3AF1BA-E63C-4C9B-B96C-B289626152EA", createdAt: Date(), updatedAt: Date(), geoPoint: GeoPoint(latitude: 37.566249, longitude: 126.992227), region: "명동구", name: "ABC 앞 떡볶이", address: "서울특별시 중구 명동10길 29", visitedCnt: 32, favoriteCnt: 13, paymentOpt: [true, true, false], openingDays: [false, true, false, true, true, true, true], menu: ["붕어빵":1000, "떡볶이":2500], bestMenu: 0, imageId: ["IMG_2468.HEIC", "IMG_2470.HEIC", "IMG_4837.HEIC", "IMG_9431.HEIC", "IMG_9432.HEIC", "IMG_9447.HEIC"], grade: 3.2, reportCnt: 0, reviewId: ["qsPzae844YI3jljYVoaT"], registerId: "egmqxtTT1Zani0UkJpUW", url: ["https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg"]),
            
            
            magazineVM: MagazineViewModel(),
            isLoading: .constant(false),
            opacity: .constant(0.8)
        )
        
    }
}
