//
//  MagnetListModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/21.
//

import Foundation
import RxCocoa
import RxSwift

struct Menu: Codable {
    let menuCode: Int
    let menuName: String
    let description: String
    let menuPhotoUrl: String
    let price: Int
}

struct MenuSection: Codable {
    let title: String
    let menu: [Menu]
}

struct DetailStore: Codable {
    let code: String
    let storeName: String
    let deliveryPrice: Int
    let minPrice: Int
    let address: String
    let bannerPhotoUrl: [String]
    let thumbnailUrl: String
    let menuSection: [MenuSection]
}

class MagnetBarHttpModel {
    static let shared = MagnetBarHttpModel()
    
    private init() { }
    
//    let data = PublishRelay<[MagnetSectionModel]>()
    var data:[MagnetSectionModel]?
    let httpManager = DeliveryHttpManager.shared
    let disposeBag = DisposeBag()
    var mainTitle: String?
    var bannerPhotoUrl: [String]?
    let navData = PublishRelay<[String]>()
    var menuTotalCount: Int?
    var storeCode: String?
    
    func loadData(code: String, completion: @escaping () -> ()) {
        httpManager.getFetch(type: .detailStore(storeCode: code))
            .subscribe(onSuccess: { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let dataModel = try JSONDecoder().decode(DetailStore.self, from: data)
                        var menuCount: Int = 0
                        self?.storeCode = dataModel.code
                        self?.mainTitle = dataModel.storeName
                        self?.bannerPhotoUrl = dataModel.bannerPhotoUrl
                        var data = [
                            MagnetSectionModel.SectionBanner(items: [BannerItem(imageUrl: dataModel.bannerPhotoUrl, mainTitle: dataModel.storeName)]),
                            MagnetSectionModel.SectionInfo(items: [InfoItem(deliveryPrice: dataModel.deliveryPrice, minPrice: dataModel.minPrice, address: dataModel.address, storeCode: dataModel.code)])
                        ]
                        var titles: [String] = []
                        dataModel.menuSection.forEach { section in
                            titles.append(section.title)
                        }
                        data.append(MagnetSectionModel.SectionSticky(items: [StrickyItem(slots: titles)]))
                        
                        dataModel.menuSection.forEach { section in
                            var items: [MenuItem] = []
                            section.menu.forEach { menu in
                                menuCount += 1
                                items.append(MenuItem(title: menu.menuName, description: menu.description, price: menu.price, thumbnail: menu.menuPhotoUrl))
                            }
                            data.append(MagnetSectionModel.SectionMenu(header: section.title, items: items))
                        }
//                        self?.data.accept(data)
                        self?.data = data
                        self?.menuTotalCount = menuCount
                        completion()
                    } catch {
                        print("decoding error: ", error.localizedDescription)
                    }
                case .failure(let error):
                    print("fail: ", error.localizedDescription)
                }
            }, onFailure: { error in
                print("error: ", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getTotalData() -> [MagnetSectionModel] {
        guard let data = data else { return [] }
        return data
    }
    
    func getSectionTitles() -> [String] {
        guard let data = data else { return [] }
        var titles:[String] = []
        data.forEach { sectionModel in
            switch sectionModel {
            case .SectionMenu(header: let header, items: _):
                titles.append(header)
            default:
                return
            }
        }
        return titles
    }
    
    func getStoreName() -> String {
        guard let mainTitle = mainTitle else { return "" }
        return mainTitle
    }
    
    func getBannerImageUrls() -> [String] {
        guard let bannerPhotoUrl = bannerPhotoUrl else { return [] }
        return bannerPhotoUrl
    }
    
    func getMenuTotalCount() -> Int {
        guard let menuTotalCount = menuTotalCount else { return 0 }
        return menuTotalCount
    }
    
    func getStoreCode() -> String {
        guard let storeCode = storeCode else {
            return ""
        }
        return storeCode
    }
}
