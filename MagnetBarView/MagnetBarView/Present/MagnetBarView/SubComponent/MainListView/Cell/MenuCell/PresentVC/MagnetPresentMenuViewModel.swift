//
//  MagnetPresentMenuViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit
import RxDataSources

struct MagnetPresentMenuViewModel {
    private let sectionManager = MagnetPresentMenuSectionManager()
    
    let data:[PresentMenuSectionModel] = [
        PresentMenuSectionModel.SectionMainTitle(items: [PresentMenuTitleItem(imageUrl: nil, mainTitle: "hi")]),
        PresentMenuSectionModel.SectionMenu(header: "가격", canSelectCount: 3, items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),
        PresentMenuSectionModel.SectionMenu(header: "가격", canSelectCount: 3, items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),
        PresentMenuSectionModel.SectionMenu(header: "가격", canSelectCount: 3, items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),
        PresentMenuSectionModel.SectionSelectCount(items: [PresentSelectCountItem(title: "s")]),
    ]
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return sectionManager.createLayout(sectionCount: self.data.count)
    }
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<PresentMenuSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PresentMenuSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .SectionMainTitle(items: let item):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentMainTitleCell.self)
                    
                    return cell
                case .SectionMenu(header: let header, canSelectCount: let count, items: let item):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentMenuCell.self)
                    return cell
                case .SectionSelectCount(items: _):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentCountSelectCell.self)
                    //   let image = self.makeMenuImage(indexPath: indexPath, url: items[indexPath.row].thumbnail ?? "")
                    
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
//            switch dataSource[indexPath.section] {
//            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetPresentMenuHeaderView.self)
                    return header
            }
//        }
        return dataSource
    }
}
