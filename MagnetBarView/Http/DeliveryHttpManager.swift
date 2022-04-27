//
//  DeliveryHttpManager.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/21.
//

import Foundation
import RxSwift

enum StoreType: String {
    case cafe = "Cafe"
    case korean = "Korean"
    case japanese = "Japanese"
    case chinese = "Chinese"
    case soup = "Soup"
    case fastFood = "FastFood"
}

enum DeliveryGetType: UrlType {
    case summaryStores(type: StoreType)
    case detailStore(storeCode: String)
    case allReviews(storeCode: String)
    case summaryReviews(storeCode: String, count: Int)
    
    var url: String {
        let BASE_URL: String = "http://localhost:8080"
        switch self {
        case .summaryStores(let type):
            return "\(BASE_URL)/delivery/summary?type=\(type.rawValue)"
        case .detailStore(let code):
            return "\(BASE_URL)/delivery/detail?storeCode=\(code)"
        case .allReviews(let code):
            return "\(BASE_URL)/delivery/reviews?storeCode=\(code)"
        case .summaryReviews(let code, let count):
            return "\(BASE_URL)/delivery/review?storeCode=\(code)&count=\(count)"
        }
    }
}

class DeliveryHttpManager {
    static let shared = DeliveryHttpManager()
    
    private init() { }
    private let httpClient = RxHttpClient()
    
    public func getFetch(type getType: DeliveryGetType) -> Single<Result<Data, CustomError>> {
        return httpClient.getHttp(type: getType, headers: nil)
    }
}
