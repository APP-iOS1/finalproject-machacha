//
//  ReverseGeocodingService.swift
//  Machacha
//
//  Created by MacBook on 2023/02/04.
//

//import Foundation
//import Alamofire
//
//func reverseget(coords : String) {
//       var alabel = ""
//       let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(coord)&sourcecrs=epsg:4326&output=json&orders=legalcode,admcode,roadaddr"
//       let header: HTTPHeaders = [ "X-NCP-APIGW-API-KEY-ID" : "t1d90xy372","X-NCP-APIGW-API-KEY" : "1iHB4AscQ8qLpAlct1s4h098xjv22nuxSzf9IbPu" ]
//       var si : [Character] = []
//       var gu : [Character] = []
//       var dong : [Character] = []
//
//       AF.request(url, method: .get, headers: header)
//           .validate(statusCode: 200..<300)
//           .responseData { response in
//               switch response.result {
//               case .success(let res):
//                   let decoder = JSONDecoder()
//                   do {
//                       self.price.removeAll()
//                       self.rateOfChange.removeAll()
//                       self.rateCalDateDiff.removeAll()
//                       self.nameLists.removeAll()
//                       self.tableView1.reloadData()
//                       let data = try decoder.decode(ReverseModel.self, from: res)
//                       //self.model.append(contentsOf: data.results)
//                       si.append(contentsOf: data.results[0].region.area1.name)
//                       let siString = String(si)
//                       gu.append(contentsOf: data.results[0].region.area2.name)
//                       let guString = String(gu)
//                       dong.append(contentsOf: data.results[0].region.area3.name)
//                       let dongString = String(dong)
//                       alabel = siString + " " + guString + " " + dongString
//                       self.searchBar.searchTextField.text = alabel
//                       self.getEstateList(name: alabel)
//                       self.setLineChartView(Areaname : alabel)
//
//                   } catch {
//                       print("erorr in decode")
//                   }
//               case .failure(let err):
//                   print(err.localizedDescription)
//               }
//           }
//       }
//
//   let marker = NMFMarker()
//   var coord = ""
//   func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//       coord = "\(latlng.lng)" + "," + "\(latlng.lat)"
//       reverseget(coords: coord)
//       marker.position = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
//       marker.isHideCollidedMarkers = true
//       marker.mapView = mapView
//
//   }

import Foundation
import Combine

enum ReverseGeocodeRouter {
    
    case get
    private enum HTTPMethod {
        case get
        
        var value: String {
            switch self {
            case .get: return "GET"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .get :
            return .get
        default:
            return .get
        }
    }
    func asURLRequest(latitude: Double, longitude: Double) throws -> URLRequest {
        // requestAddress -> 주소 검색할 String 값 받아야 합니다
        let queryURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(longitude),\(latitude)&sourcecrs=epsg:4326&orders=addr&output=json"
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //NaverAPIEnum.naverApI.clientID
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        
        //나중에 보안키 빼야함
        request.setValue("zvl4jgdvym", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.setValue("yOxBP59CvSOVeyBM19ecoB8qTwdqCrkS5gi5dDVj", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.httpMethod = method.value
        return request
    }
    
}


enum ReverseGeocodeService {
    
    static func getReverseGeocode(latitude: Double, longitude: Double) -> AnyPublisher<Welcome, Error> {
        // geocode 쿼리 url
        let queryURL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(longitude),\(latitude)&sourcecrs=epsg:4326&orders=addr&output=json"
        
        //MARK: URL의 string:은 영문, 숫자와 특정 문자만 인식 가능하며, 한글, 띄어쓰기 등은 인식하지 못합니다.!!
        // 분명 한글로 요청이 올테니 인코딩
        let encodeQueryURL = queryURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = URLRequest(url: URL(string: encodeQueryURL)!)
        do {
            request = try ReverseGeocodeRouter.get.asURLRequest(latitude: latitude, longitude: longitude)
        } catch {
            print("http error")
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map{ $0.data}
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

struct ReverseGeocodeDTO: Codable {
    let results: [Welcome]
}


final class NaverAPIViewModel: ObservableObject {
    
    var subscription = Set<AnyCancellable>()
    
    @Published var reverseGeocodeResult = [Welcome]()
    @Published var address : String = "불러오는중"
    @Published var region : String = "불러오는중"
    
    init(){
        reverseGeocodeResult = []
    }
    var fetchGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertGeocodeSuccess = PassthroughSubject<(), Never>()
    
    var fetchReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    var insertReverseGeocodeSuccess = PassthroughSubject<(), Never>()
    
    
    func fetchReverseGeocode(latitude: Double, longitude: Double) {
        
        ReverseGeocodeService.getReverseGeocode(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                //unowned를 여기에 쓰는게 맞을까요?
            } receiveValue: { [unowned self] (data: Welcome) in
                reverseGeocodeResult = [data]
                region = "\(data.results[0].region.area1.name) \(data.results[0].region.area2.name) \(data.results[0].region.area3.name)"
                let number2 = data.results[0].land.number2
                if number2 == "" {
                    address = "\(region) \(data.results[0].land.number1)"
                }else{
                    address = "\(region) \(data.results[0].land.number1)-\(number2)"
                }
                fetchReverseGeocodeSuccess.send()
            }.store(in: &subscription)
        print("fetchReverseGeocode")
    }
}
