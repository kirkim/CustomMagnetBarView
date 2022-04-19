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
    let bannerCellViewModel = MagnetBannerCellViewModel()
    let infoCellViewModel = MagnetInfoViewModel()
    let stickyViewModel: RemoteMainListBarViewModel
    
    // View -> ViewModel
    let scrollEvent = PublishRelay<(CGFloat, CGFloat)>()
    let stickyHeaderOn = PublishRelay<Bool>()
    let changeSection = PublishRelay<Int>()
    
    // ViewModel -> ParentViewModel
    let presentVC: Signal<UIViewController>
    
    let data = [
        RxStaticSectionData(header: "hello", items: [Sample()]),
        RxStaticSectionData(header: "hello", items: [Sample()]),
        RxStaticSectionData(header: "hello", items: []),
        RxStaticSectionData(header: "추천메뉴", items: [
            Sample(title: "콥샐러드", description1: "계란, 베이컨, 옥수수, 올리브, 병아리콩, 토마토", description2: "추천 드레싱: 갈릭", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "아보치킨샐러드", description1: "아보카도, 치킨, 견과류, 그리노파다노, 토마토", description2: "추천 드레싱: 갈릭", price: 9500, thumbnail: "review1.jpeg"),
            Sample(title: "리코타샐러드", description1: "리코타치즈, 올리브, 견과류, 방울토마토",description2: "추천 드레싱: 발사믹", price: 8000, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "샐러드", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션2", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션3", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션4", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션섹션5", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션6", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")
        ]),
        RxStaticSectionData(header: "섹션27", items: [
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "hi1", description1: "des1", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "22222", description1: "des1asdsadsadsadsad", price: 8500, thumbnail: "review1.jpeg"),
            Sample(title: "3333", description1: "dessadsadsadsadsa1", price: 8500, thumbnail: "review1.jpeg")

        ])
    ]
    
    private let mainTitle: String
    
    //////////
    // View -> ViewModel
    let pageChanging = PublishRelay<Int>()
    
    // ViewModel -> View
//    let scrolledPage: Signal<IndexPath>
    
    // TabBarView -> ViewModel -> View
    let slotChanged = PublishRelay<IndexPath>()
    ////////
    
    init(mainTitle: String) {
        self.mainTitle = mainTitle
        let tempdata = data[3...]
        let itemTitles = tempdata.map { data -> String in
            return data.header
        }
        stickyViewModel = RemoteMainListBarViewModel(itemTitles: itemTitles)
        
        MagnetListSectionManager().calculateSectionOriginY(data: data)

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

    func dataSource() -> RxCollectionViewSectionedReloadDataSource<RxStaticSectionData> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<RxStaticSectionData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                if indexPath.section == 0 {
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetBannerCell.self)
                    cell.setData(title: mainTitle)
                    cell.layout()
                    cell.bind(bannerCellViewModel)
                    return cell
                } else if indexPath.section == 1 {
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetInfoCell.self)
                    cell.bind(infoCellViewModel)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetMenuCell.self)
                    cell.setData(data: item)
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            if indexPath.section == 2 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetStickyHeaderCell.self)
                header.bind(stickyViewModel)
                return header
            } else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
                header.setData(title: dataSource[indexPath.section].header)
                return header
            }
        }
        
        return dataSource
    }

    func calculateSectionPositionY() {
        
    }
}
