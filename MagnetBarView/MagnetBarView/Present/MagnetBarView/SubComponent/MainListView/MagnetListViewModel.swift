//
//  MagnetListViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import RxCocoa
import RxDataSources

struct MagnetListViewModel {
//    let bannerCellViewModel = MagnetBannerCellViewModel()
    let infoCellViewModel = MagnetInfoViewModel()
    let stickyViewModel = RemoteMainListBarViewModel()
    
    // View -> ViewModel
    let scrollEvent = PublishRelay<(CGFloat, CGFloat)>()
    let stickyHeaderOn = PublishRelay<Bool>()
    let changeSection = PublishRelay<Int>()
    
    // ViewModel -> ParentViewModel
    let presentVC: Signal<UIViewController>
    
    let data = [
        MagnetSectionModel.SectionBanner(items: [ BannerItem(imageUrl: ["space_bread1.jpeg", "space_bread2.jpeg", "space_bread3.jpeg"], mainTitle: "히히히") ]),
        MagnetSectionModel.SectionInfo(items: [ InfoItem(deliveryPrice: 3000, minPrice: 12000, address: "돈암동", storeCode: "11") ]),
        MagnetSectionModel.SectionSticky(items: [ StrickyItem(slots: ["1", "22222", "3333333", "4444444", "555555"]) ]),
        MagnetSectionModel.SectionMenu(header: "추천메뉴", items: [
            MenuItem(title: "콥샐러드", description: "계란, 베이컨, 옥수수, 올리브, 병아리콩, 토마토 추천 드레싱: 갈릭", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "아보치킨샐러드", description: "아보카도, 치킨, 견과류, 그리노파다노, 토마토 추천 드레싱: 갈릭", price: 9500, thumbnail: "review1.jpeg"),
            MenuItem(title: "리코타샐러드", description: "리코타치즈, 올리브, 견과류, 방울토마토 추천 드레싱: 발사믹", price: 8000, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "샐러드", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션2", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션3", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션4", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션섹션5", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션6", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        MagnetSectionModel.SectionMenu(header: "섹션27", items: [
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "hi1", description: "des1", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "22222", description: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            MenuItem(title: "3333", description: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ])
    ]
    
    //////////
    // View -> ViewModel
    let pageChanging = PublishRelay<Int>()
    
    // ViewModel -> View
//    let scrolledPage: Signal<IndexPath>
    
    // TabBarView -> ViewModel -> View
    let slotChanged = PublishRelay<IndexPath>()
    ////////
    
    init() {
//        let tempdata = data[3...]
//        let itemTitles = tempdata.map { data -> String in
//            return data.header
//        }
//        stickyViewModel = RemoteMainListBarViewModel(itemTitles: itemTitles)

        presentVC = infoCellViewModel.popVC
            .map { type -> UIViewController in
                switch type {
                case .popReviewVC:
                    return MagnetReviewVC()
                case .review(indexPath: let indexPath):
                    return MagnetReviewVC()
                }
            }
            .asSignal()
    }

    func dataSource() -> RxCollectionViewSectionedReloadDataSource<MagnetSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MagnetSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .SectionBanner(items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetBannerCell.self)
                    let bannerCellViewModel = MagnetBannerCellViewModel(imageName: items[indexPath.row].imageUrl)
                    cell.setData(title: items[indexPath.row].mainTitle)
                    cell.layout()
                    cell.bind(bannerCellViewModel)
                    return cell
                case .SectionInfo(items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetInfoCell.self)
                    cell.bind(infoCellViewModel)
                    return cell
                case .SectionSticky(items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetStickyCell.self)
                    
                    cell.bind(stickyViewModel)
                    return cell
                case .SectionMenu(header: _, items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetMenuCell.self)
                    cell.setData(data: items[indexPath.row])
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch dataSource[indexPath.section] {
            case .SectionMenu(header: let headerValue, items: _):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
                    header.setData(title: headerValue)
                    return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
                    return header
            }
        }
        
        return dataSource
    }
}
