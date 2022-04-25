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

class MagnetBarModel {
    let data = PublishRelay<[MagnetSectionModel]>()
    let httpManager = DeliveryHttpManager()
    let disposeBag = DisposeBag()
    let mainTitle = PublishRelay<String>()
    let navData = PublishRelay<[String]>()
    
    func loadData(code: String) {
        httpManager.getFetch(type: .detailStore(storeCode: code))
            .subscribe(onSuccess: { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        let dataModel = try JSONDecoder().decode(DetailStore.self, from: data)
                        self?.mainTitle.accept(dataModel.storeName)
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
                                items.append(MenuItem(title: menu.menuName, description: menu.description, price: menu.price, thumbnail: menu.menuPhotoUrl))
                            }
                            data.append(MagnetSectionModel.SectionMenu(header: section.title, items: items))
                        }
                        self?.data.accept(data)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print("fail: ", error.localizedDescription)
                }
            }, onFailure: { error in
                print("error: ", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadView(completion: @escaping ([MagnetSectionModel]) -> ()) {
        self.data
            .subscribe { data in
                completion(data)
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("completed!")
            } onDisposed: {
                print("dispoesed!")
            }
            .disposed(by: disposeBag)
    }
}
